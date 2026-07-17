# Model benchmark harness

Compares LLMs head-to-head on the real GenUI task — the same composed system
prompt the app uses, parsed by the same GenUI parser — without rendering any UI.
It drives `SimulatorRepository` directly, so it runs headless under
`flutter test` and works anywhere (local or CI), with no Firebase, no browser,
and no desktop build.

Metrics per model: time to first chunk, total round-trip time, error rate, and
chunk/token counts. A turn counts as an error if the request throws **or** the
model's output fails to parse into a valid GenUI surface — that parse step is
the schema validation.

## Setup

```sh
cp benchmark/keys.env.example benchmark/keys.env
```

Fill in keys for the providers you want. Any model without a key is skipped.
Every model (Gemini included) uses a direct provider API. Confirm the model id
strings in `benchmark/src/benchmark_models.dart` against each provider's current
catalog — they change often.

## Run locally

```sh
fvm dart run tool/run_benchmark.dart                 # full sweep, then report
fvm dart run tool/run_benchmark.dart --only-new      # only models without a
                                                     # result file yet
fvm dart run tool/run_benchmark.dart --only-new --rerun-failed  # + retry
                                                     # models with a failure
BENCHMARK_ITERATIONS=1 fvm dart run tool/run_benchmark.dart   # quick dry run
open benchmark/report.html
```

`--only-new` benchmarks only models that don't yet have a
`benchmark/results/<id>.json`, leaving existing results in place. Handy after
adding a new model so you fill in just the gap without re-paying for the rest.
`--rerun-failed` additionally re-runs any model whose stored result has a failed
turn (an error or a turn that produced no surface). The two compose: with both,
a run fills in new models and retries failures while never touching a model that
already passed cleanly — a re-run overwrites that model's result and deletes its
`.failures.txt`, so a now-passing model's old failures are cleared.

Or directly:

```sh
fvm flutter test benchmark/benchmark_test.dart --dart-define-from-file=benchmark/keys.env
fvm dart run tool/build_benchmark_report.dart
```

Models run **round-robin**: one iteration of each model per cycle, with the
order re-shuffled each cycle. This spreads every provider's requests across the
whole run instead of firing them in a burst, so a provider's rate/token limits
aren't tripped and no model is penalized by running late. Results are written
after every iteration, so an interrupted run (e.g. running out of provider
tokens mid-sweep) still leaves partial data for every model.

Tune with env vars: `BENCHMARK_ITERATIONS` (default 5), `BENCHMARK_TURNS`
(default 3), `BENCHMARK_COOLDOWN_SECONDS` (default 0 — a fixed delay before each
request; interleaving already spaces providers, so raise it only if one still
rate-limits).

### Debugging failures

When a turn fails (a transport error, or output the GenUI parser rejects), the
full detail is written to `benchmark/results/<id>.failures.txt`: the error(s) in
full plus the raw model output for that turn — usually the quickest way to see
exactly what a model emitted that broke parsing.

### Reading the report

- **Avg round-trip** and **avg per pass** are wall-clock and comparable across
  providers — these are the headline numbers.
- **TTFC** and **avg chunks** (marked †) reflect each provider's streaming
  granularity (OpenAI streams token-by-token; Google and others send fewer,
  larger chunks), so only compare them within a provider.
- **Avg output tokens** is completion tokens only; for reasoning models this
  includes thinking tokens, so it drops on the `-no-thinking` variants.

## Run on CI

`.github/workflows/benchmark.yaml` runs on an Ubuntu runner. It is
**manual-only** (`workflow_dispatch`) — it makes real, paid API calls, so it
never runs on a schedule. `workflow_dispatch` requires write access to the
repo, so only maintainers can start it. It reads keys from repository secrets,
runs the headless benchmark, builds the report, and uploads
`benchmark/report.html` + the raw results as a workflow artifact.

Runs are **incremental by default**: each run first restores the previous
successful run's results, then the `mode` dispatch input decides what to run.
`new-and-failed` (the default) benchmarks models without a result yet **and**
re-runs any whose restored result had a failed turn, while leaving cleanly-passed
models untouched — so failures are retried and successes are never re-paid for.
`new` fills only missing models; `all` re-benchmarks everything from scratch.
Restore only pulls from a run whose job concluded **success**, so a run must
stay green to become the next run's baseline; recorded API/GenUI failures are
data and keep the job green, so only a hard crash or timeout breaks the chain.

Each run also publishes the built report to its own Firebase Hosting site
(`genui-benchmarks.web.app`). This deploy is decoupled from the Flutter app's
deploy in `main.yaml`: the static report needs none of the app's Firebase
config, so the workflow writes a minimal `firebase.json` inline and deploys
with the `FIREBASE_SERVICE_ACCOUNT` and `FIREBASE_PROJECT_ID` secrets only (no
`FIREBASE_JSON`/`FIREBASERC` secret involved).

Finally, each run publishes the machine-readable `benchmark/genui-benchmarks.json`
to verygood.ventures by opening (or updating) a PR on
`VGVentures/vgv-website-claude`. It mirrors that repo's own `oss-stats` pattern:
a fixed branch (`chore/update-genui-benchmarks`), force-pushed and reused, with
one open PR at a time writing `astro/src/data/genui-benchmarks.json`. The push
uses `WEBSITE_PR_TOKEN` — a fine-grained PAT with `contents:write` +
`pull-requests:write` on the website repo, **not** this repo's `GITHUB_TOKEN` —
so the website's CI (build + zod schema validation, spell check, preview deploy)
runs on the PR and a malformed payload fails that build before it can ship. The
JSON shape is fixed by `astro/src/lib/genui-benchmarks.ts` in the website repo.
Like the Firebase deploy, this step is `continue-on-error`, so a publish failure
never breaks the incremental-restore chain.

Required repository secrets (omit any provider you don't want):
`GEMINI_API_KEY`, `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `KIMI_API_KEY`,
`DEEPSEEK_API_KEY`, `INCEPTION_API_KEY`. The Firebase Hosting deploy also needs
`FIREBASE_SERVICE_ACCOUNT` and `FIREBASE_PROJECT_ID`. The website PR needs
`WEBSITE_PR_TOKEN`.

## How it works

- `benchmark/src/benchmark_models.dart` — the model list (direct providers,
  incl. Kimi/DeepSeek/Inception via OpenAI-compatible `baseUrl`). Edit to add
  models.
- `benchmark/src/timing_chat_model.dart` — wraps the model and times each round
  trip. The single latency-measurement point.
- `benchmark/src/benchmark_runner.dart` — drives `SimulatorRepository` for
  N iterations × M turns and records per-turn metrics.
- `benchmark/src/benchmark_recorder.dart` — accumulates metrics; serializes JSON.
- `benchmark/benchmark_test.dart` — `flutter test` entry; one test per model,
  skipped when its key is absent; writes `benchmark/results/<id>.json`.
- `tool/run_benchmark.dart` — runs the test + report.
- `tool/build_benchmark_report.dart` — aggregates results into
  `benchmark/report.html` (the human report) and
  `benchmark/genui-benchmarks.json` (the machine data file the website consumes,
  whose shape is fixed by the website's zod schema).

`benchmark/keys.env`, `benchmark/results/`, `benchmark/report.html`,
`benchmark/genui-benchmarks.json`, and `benchmark/public/` (the staged Hosting
output) are gitignored.

## Adding a model later (e.g. GLM)

Add one `BenchmarkModel` to `benchmarkModels` in
`benchmark/src/benchmark_models.dart`. If it is OpenAI-compatible, use
`OpenAIProvider` with its `baseUrl`, like the Kimi and DeepSeek entries.

## Note on the Firebase transport

The app ships Gemini through Firebase in production; this headless harness uses
the direct Google API instead (Firebase needs the full app + App Check and
can't run headless). The latency numbers are the model's, not Firebase's
transport overhead. To measure the Firebase path specifically, run the app
manually and watch the network panel.
