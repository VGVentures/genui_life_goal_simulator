// Aggregates benchmark/results/*.json into a single benchmark/report.html.
//
// Run after tool/run_benchmark.sh:
//   fvm dart run tool/build_benchmark_report.dart
//
// Each input file is the metrics map produced by the integration test
// (modelId, iterations, turns[]). This script computes per-model aggregates
// and writes a dependency-free HTML report.

import 'dart:convert';
import 'dart:io';

void main() {
  final resultsDir = Directory('benchmark/results');
  if (!resultsDir.existsSync()) {
    stderr.writeln(
      'No benchmark/results directory. Run tool/run_benchmark.sh first.',
    );
    exitCode = 1;
    return;
  }

  final files =
      resultsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  if (files.isEmpty) {
    stderr.writeln('No .json result files found in benchmark/results.');
    exitCode = 1;
    return;
  }

  final summaries = <_ModelSummary>[];
  for (final file in files) {
    try {
      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      summaries.add(_ModelSummary.fromJson(data));
    } on Object catch (e) {
      stderr.writeln('Skipping ${file.path}: $e');
    }
  }

  if (summaries.isEmpty) {
    stderr.writeln('No parseable results.');
    exitCode = 1;
    return;
  }

  // Rank by average total round-trip (fastest first); models with no
  // successful turns sink to the bottom.
  summaries.sort((a, b) {
    final av = a.avgTotalMs ?? double.infinity;
    final bv = b.avgTotalMs ?? double.infinity;
    return av.compareTo(bv);
  });

  final html = _buildHtml(summaries);
  final out = File('benchmark/report.html')..writeAsStringSync(html);
  stdout.writeln('Wrote ${out.path} (${summaries.length} model(s)).');
}

class _ModelSummary {
  _ModelSummary({
    required this.modelId,
    required this.iterations,
    required this.totalTurns,
    required this.failedTurns,
    required this.avgTotalMs,
    required this.avgTtfcMs,
    required this.p95TtfcMs,
    required this.avgPerIterationMs,
    required this.avgChunks,
    required this.avgTokens,
  });

  factory _ModelSummary.fromJson(Map<String, dynamic> json) {
    final modelId = (json['modelId'] ?? 'unknown') as String;
    final iterations = (json['iterations'] ?? 0) as int;
    final turns = (json['turns'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();

    // A turn fails if it errored or produced no valid GenUI surface (the
    // schema-validation signal). Surface info may be absent in older result
    // files, so default missing surfaceProduced to true.
    bool isFailure(Map<String, dynamic> t) {
      final error = t['error'];
      final surfaceProduced = (t['surfaceProduced'] ?? true) as bool;
      return error != null || !surfaceProduced;
    }

    final totalTurns = turns.length;
    final failed = turns.where(isFailure).length;
    final successful = turns.where((t) => !isFailure(t)).toList();

    final totals = successful
        .map((t) => (t['totalMs'] as num).toDouble())
        .toList();
    final ttfcs = successful
        .where((t) => t['timeToFirstChunkMs'] != null)
        .map((t) => (t['timeToFirstChunkMs'] as num).toDouble())
        .toList();
    final chunks = successful
        .map((t) => (t['chunkCount'] as num).toDouble())
        .toList();
    // Output (completion) tokens, not total — total is dominated by the large
    // fixed system prompt re-sent every turn, so it's the same for every model
    // and tells us nothing. For reasoning models the completion count includes
    // thinking tokens, so this also reflects thinking cost.
    final tokens = successful
        .where((t) => t['responseTokens'] != null)
        .map((t) => (t['responseTokens'] as num).toDouble())
        .toList();

    // Total time to traverse a full pass: sum the successful turns per
    // iteration, averaged across iterations that had any successful turn.
    final perIteration = <int, double>{};
    for (final t in successful) {
      final iter = (t['iteration'] ?? 0) as int;
      perIteration[iter] =
          (perIteration[iter] ?? 0) + (t['totalMs'] as num).toDouble();
    }

    return _ModelSummary(
      modelId: modelId,
      iterations: iterations,
      totalTurns: totalTurns,
      failedTurns: failed,
      avgTotalMs: _avg(totals),
      avgTtfcMs: _avg(ttfcs),
      p95TtfcMs: _percentile(ttfcs, 95),
      avgPerIterationMs: _avg(perIteration.values.toList()),
      avgChunks: _avg(chunks),
      avgTokens: _avg(tokens),
    );
  }

  final String modelId;
  final int iterations;
  final int totalTurns;
  final int failedTurns;
  final double? avgTotalMs;
  final double? avgTtfcMs;
  final double? p95TtfcMs;
  final double? avgPerIterationMs;
  final double? avgChunks;
  final double? avgTokens;

  double get errorRate => totalTurns == 0 ? 0 : failedTurns / totalTurns;
}

double? _avg(List<double> values) {
  if (values.isEmpty) return null;
  return values.reduce((a, b) => a + b) / values.length;
}

double? _percentile(List<double> values, int p) {
  if (values.isEmpty) return null;
  final sorted = [...values]..sort();
  final rank = (p / 100) * (sorted.length - 1);
  final low = rank.floor();
  final high = rank.ceil();
  if (low == high) return sorted[low];
  final weight = rank - low;
  return sorted[low] * (1 - weight) + sorted[high] * weight;
}

String _ms(double? v) => v == null ? '—' : '${v.round()} ms';
String _num(double? v) => v == null ? '—' : v.toStringAsFixed(1);
String _pct(double v) => '${(v * 100).toStringAsFixed(1)}%';

String _buildHtml(List<_ModelSummary> summaries) {
  final maxTotal = summaries
      .map((s) => s.avgTotalMs ?? 0)
      .fold<double>(0, (a, b) => a > b ? a : b);

  final rows = StringBuffer();
  for (var i = 0; i < summaries.length; i++) {
    final s = summaries[i];
    final barWidth = maxTotal == 0 || s.avgTotalMs == null
        ? 0
        : ((s.avgTotalMs! / maxTotal) * 100).round();
    final errClass = s.errorRate > 0 ? 'err' : 'ok';
    final fastest = i == 0 && s.avgTotalMs != null ? ' class="fastest"' : '';
    final turnsPerIter = (s.totalTurns / (s.iterations == 0 ? 1 : s.iterations))
        .toStringAsFixed(0);
    rows.writeln('''
      <tr$fastest>
        <td class="model">${_escape(s.modelId)}</td>
        <td class="num">
          <div class="bar-wrap"><div class="bar" style="width:$barWidth%"></div></div>
          <span>${_ms(s.avgTotalMs)}</span>
        </td>
        <td class="num">${_ms(s.avgTtfcMs)}</td>
        <td class="num">${_ms(s.p95TtfcMs)}</td>
        <td class="num">${_ms(s.avgPerIterationMs)}</td>
        <td class="num $errClass">${_pct(s.errorRate)}</td>
        <td class="num">${_num(s.avgChunks)}</td>
        <td class="num">${_num(s.avgTokens)}</td>
        <td class="num muted">$turnsPerIter × ${s.iterations}</td>
      </tr>''');
  }

  return '''
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Model Benchmark Report · Very Good Ventures</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --vgv-blue: #2A48DE;
      --vgv-navy: #0A1530;
      --eigengrau: #16161D;
      --surface-light: #FAFBFF;
      --pale-blue: #F3F6FF;
      --blue-light: #459CFF;
      --gray: #D2D5DD;
      --gray-deep: #838998;
      --vgv-pink: #FF1C81;
    }
    * { box-sizing: border-box; }
    body {
      font-family: 'Poppins', system-ui, sans-serif;
      font-size: 15px;
      line-height: 1.6;
      margin: 0;
      color: var(--eigengrau);
      background: var(--surface-light);
    }
    .hero {
      background: linear-gradient(135deg, var(--vgv-navy) 0%, var(--vgv-blue) 100%);
      color: #fff;
      padding: 3.5rem 1.5rem 3rem;
    }
    /* Full-width: the table fills the window; padding on .hero/main insets it. */
    .label {
      text-transform: uppercase;
      letter-spacing: 0.2em;
      font-size: 0.72rem;
      font-weight: 600;
      color: var(--blue-light);
      margin: 0 0 0.6rem;
    }
    h1 {
      font-size: clamp(1.8rem, 4vw, 2.6rem);
      font-weight: 700;
      line-height: 1.08;
      margin: 0 0 0.6rem;
    }
    .hero p { color: rgba(255, 255, 255, 0.7); margin: 0; max-width: 60ch; }
    main { padding: 2.5rem 1.5rem 3rem; }
    .card {
      background: #fff;
      border: 1px solid rgba(10, 21, 48, 0.08);
      border-radius: 20px;
      padding: 0.5rem 0.5rem 0.25rem;
      box-shadow: 0 12px 40px rgba(10, 21, 48, 0.06);
      overflow-x: auto;
      animation: rise 0.6s ease-out both;
    }
    table { border-collapse: collapse; width: 100%; }
    th, td {
      padding: 0.85rem 0.9rem;
      text-align: right;
      border-bottom: 1px solid rgba(10, 21, 48, 0.08);
      white-space: nowrap;
    }
    th {
      font-size: 0.68rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.16em;
      color: var(--gray-deep);
    }
    th:first-child, td.model { text-align: left; }
    td.model { font-weight: 600; color: var(--eigengrau); }
    td.num { font-variant-numeric: tabular-nums; }
    td.muted { color: var(--gray-deep); }
    tbody tr:last-child td { border-bottom: none; }
    tr.fastest td { background: var(--pale-blue); }
    tr.fastest td.model {
      box-shadow: inset 3px 0 0 var(--vgv-blue);
      border-radius: 8px 0 0 8px;
    }
    .bar-wrap {
      display: inline-block;
      width: 120px;
      height: 8px;
      background: rgba(10, 21, 48, 0.08);
      border-radius: 9999px;
      vertical-align: middle;
      margin-right: 0.6rem;
      overflow: hidden;
    }
    .bar {
      height: 100%;
      border-radius: 9999px;
      background: linear-gradient(90deg, var(--vgv-navy), var(--vgv-blue));
    }
    td.err { color: var(--vgv-pink); font-weight: 600; }
    td.ok { color: var(--gray-deep); }
    thead th[title] {
      cursor: help;
      text-decoration: underline dotted rgba(131, 137, 152, 0.55);
      text-underline-offset: 4px;
    }
    .glossary-title {
      max-width: 80ch;
      margin: 2.25rem 0 0.6rem;
      font-size: 0.72rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.16em;
      color: var(--gray-deep);
    }
    .glossary {
      max-width: 80ch;
      margin: 0;
      padding: 0;
      list-style: none;
      font-size: 0.88rem;
      color: rgba(22, 22, 29, 0.7);
    }
    .glossary li {
      padding: 0.45rem 0;
      border-top: 1px solid rgba(10, 21, 48, 0.06);
    }
    .glossary li:first-child { border-top: none; }
    .glossary strong { color: var(--eigengrau); font-weight: 600; }
    .glossary code {
      font-size: 0.85em;
      background: rgba(10, 21, 48, 0.06);
      padding: 0.05rem 0.3rem;
      border-radius: 4px;
    }
    .footnote {
      max-width: 80ch;
      margin: 1.25rem 0 0;
      color: rgba(22, 22, 29, 0.55);
      font-size: 0.82rem;
      line-height: 1.6;
    }
    @keyframes rise {
      from { opacity: 0; transform: translateY(16px); }
      to { opacity: 1; transform: none; }
    }
    @media (prefers-reduced-motion: reduce) {
      .card { animation: none; }
    }
    .caveat {
      max-width: 80ch;
      margin: 1.5rem 0 0;
      padding: 0.9rem 1.1rem;
      background: rgba(255, 255, 255, 0.08);
      border-left: 3px solid var(--blue-light);
      border-radius: 8px;
      color: #fff;
      font-size: 0.95rem;
    }
    .caveat strong { font-weight: 700; }
  </style>
</head>
<body>
  <header class="hero">
    <div class="hero-inner">
      <p class="label">Very Good Ventures · GenUI</p>
      <h1>Model Benchmark Report</h1>
      <p>Average over all timed round trips, sorted fastest-first by total
      round-trip time. Latency stats exclude failed turns; the error rate counts
      them.</p>
      <p class="caveat"><strong>Speed is only one dimension.</strong> The
      quality of the experience matters just as much, and these benchmarks
      cannot measure that.</p>
    </div>
  </header>
  <main>
    <div class="card">
      <table>
        <thead>
          <tr>
            <th title="Model id. A -no-thinking row is the same model with thinking disabled.">Model</th>
            <th title="Mean wall-clock time per turn (request sent until the stream completes), over successful turns. Comparable across providers.">Avg round-trip</th>
            <th title="Time to first chunk: request sent until the first non-empty streamed chunk. Compare within a provider only.">Avg TTFC †</th>
            <th title="95th-percentile time to first chunk (tail latency). Compare within a provider only.">p95 TTFC †</th>
            <th title="Mean time to complete one full pass — all turns in an iteration summed. Comparable across providers.">Avg per pass</th>
            <th title="Share of turns that errored or produced no valid GenUI surface.">Error rate</th>
            <th title="Mean non-empty streamed chunks per turn. Reflects each provider's streaming granularity.">Avg chunks †</th>
            <th title="Mean completion tokens per turn (excludes the prompt). Includes reasoning tokens for thinking models.">Avg output tokens</th>
            <th title="Turns per iteration × iteration count behind each average.">Turns × iters</th>
          </tr>
        </thead>
        <tbody>
$rows
        </tbody>
      </table>
    </div>
    <p class="glossary-title">Column glossary (hover any header for a tooltip)</p>
    <ul class="glossary">
      <li><strong>Model</strong> — the model id. A <code>-no-thinking</code> row
      is the same model with thinking disabled. The fastest row is highlighted.</li>
      <li><strong>Avg round-trip</strong> — mean wall-clock time per turn, from
      request sent to stream complete, over successful turns. Comparable across
      providers; this is the headline metric.</li>
      <li><strong>Avg TTFC †</strong> — time to first chunk: request sent until
      the first non-empty streamed chunk.</li>
      <li><strong>p95 TTFC †</strong> — 95th-percentile time to first chunk, i.e.
      tail latency.</li>
      <li><strong>Avg per pass</strong> — mean time to complete one full pass
      (all turns in an iteration summed). Comparable across providers.</li>
      <li><strong>Error rate</strong> — share of turns that errored or produced
      no valid GenUI surface.</li>
      <li><strong>Avg chunks †</strong> — mean number of non-empty streamed
      chunks per turn.</li>
      <li><strong>Avg output tokens</strong> — mean completion tokens per turn
      (excludes the prompt). Includes reasoning tokens for thinking models, so it
      drops on <code>-no-thinking</code> rows.</li>
      <li><strong>Turns × iters</strong> — turns per iteration × iteration count
      behind each average.</li>
    </ul>
    <p class="footnote">† TTFC and chunk counts reflect each provider's streaming
    granularity — OpenAI streams token-by-token, Google and others send fewer,
    larger chunks — so compare them only within a provider, not across. Latency
    and token stats are shown only when the provider reports them.</p>
  </main>
</body>
</html>
''';
}

String _escape(String s) =>
    s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
