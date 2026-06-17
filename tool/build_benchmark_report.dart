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
    final tokens = successful
        .where((t) => t['totalTokens'] != null)
        .map((t) => (t['totalTokens'] as num).toDouble())
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
    .hero-inner, main { max-width: 1040px; margin: 0 auto; }
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
    thead th { border-bottom: 2px solid rgba(10, 21, 48, 0.12); }
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
    .notes {
      max-width: 80ch;
      margin: 1.75rem auto 0;
      color: rgba(22, 22, 29, 0.55);
      font-size: 0.85rem;
    }
    @keyframes rise {
      from { opacity: 0; transform: translateY(16px); }
      to { opacity: 1; transform: none; }
    }
    @media (prefers-reduced-motion: reduce) {
      .card { animation: none; }
    }
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
    </div>
  </header>
  <main>
    <div class="card">
      <table>
        <thead>
          <tr>
            <th>Model</th>
            <th>Avg round-trip</th>
            <th>Avg TTFC</th>
            <th>p95 TTFC</th>
            <th>Avg per pass</th>
            <th>Error rate</th>
            <th>Avg chunks</th>
            <th>Avg tokens</th>
            <th>Turns × iters</th>
          </tr>
        </thead>
        <tbody>
$rows
        </tbody>
      </table>
    </div>
    <p class="notes">TTFC = time to first chunk. "Avg per pass" = mean total
    time to traverse one full set of turns. Tokens shown only when the provider
    reports usage.</p>
  </main>
</body>
</html>
''';
}

String _escape(String s) =>
    s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
