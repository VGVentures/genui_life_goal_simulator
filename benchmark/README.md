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
BENCHMARK_ITERATIONS=1 fvm dart run tool/run_benchmark.dart   # quick dry run
open benchmark/report.html
```

Or directly:

```sh
fvm flutter test benchmark/benchmark_test.dart --dart-define-from-file=benchmark/keys.env
fvm dart run tool/build_benchmark_report.dart
```

## Run on CI

`.github/workflows/benchmark.yaml` runs the full suite on an Ubuntu runner
(manual `workflow_dispatch`, plus a weekly schedule). It reads keys from
repository secrets, runs the headless benchmark, builds the report, and uploads
`benchmark/report.html` + the raw results as a workflow artifact.

Required repository secrets (omit any provider you don't want):
`GEMINI_API_KEY`, `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `KIMI_API_KEY`,
`DEEPSEEK_API_KEY`.

## How it works

- `benchmark/src/benchmark_models.dart` — the model list (direct providers,
  incl. Kimi/DeepSeek via OpenAI-compatible `baseUrl`). Edit to add models.
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

`benchmark/keys.env`, `benchmark/results/`, and `benchmark/report.html` are
gitignored.

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
