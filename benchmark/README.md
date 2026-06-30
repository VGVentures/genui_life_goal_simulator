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
BENCHMARK_ITERATIONS=1 fvm dart run tool/run_benchmark.dart   # quick dry run
open benchmark/report.html
```

`--only-new` benchmarks only models that don't yet have a
`benchmark/results/<id>.json`, leaving existing results in place. Handy after
adding a new model so you fill in just the gap without re-paying for the rest.

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

`.github/workflows/benchmark.yaml` runs on an Ubuntu runner (manual
`workflow_dispatch`, plus a weekly schedule). It reads keys from repository
secrets, runs the headless benchmark, builds the report, and uploads
`benchmark/report.html` + the raw results as a workflow artifact.

Runs are **incremental by default**: each run first restores the previous
successful run's results, then (when the `only_new` dispatch input is true,
the default) benchmarks only models without a result yet, so newly added
models get filled in without re-paying for the rest. Set `only_new` to false
to re-benchmark every model from scratch.

On a manual run (`workflow_dispatch`), the built report is published to its own
Firebase Hosting site (`genui-benchmarks.web.app`). Scheduled runs still
benchmark and upload the report artifact but do not publish — deploying to the
live site is an explicit, human-triggered action, and `workflow_dispatch`
already requires write access to the repo. This deploy is decoupled from the
Flutter app's deploy in `main.yaml`: the static report needs none of the app's
Firebase config, so the workflow writes a minimal `firebase.json` inline and
deploys with the `FIREBASE_SERVICE_ACCOUNT` and `FIREBASE_PROJECT_ID` secrets
only (no `FIREBASE_JSON`/`FIREBASERC` secret involved).

Required repository secrets (omit any provider you don't want):
`GEMINI_API_KEY`, `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `KIMI_API_KEY`,
`DEEPSEEK_API_KEY`, `INCEPTION_API_KEY`. The Firebase Hosting deploy also needs
`FIREBASE_SERVICE_ACCOUNT` and `FIREBASE_PROJECT_ID`.

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
  `benchmark/report.html`.

`benchmark/keys.env`, `benchmark/results/`, `benchmark/report.html`, and
`benchmark/public/` (the staged Hosting output) are gitignored.

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
