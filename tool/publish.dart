// Allow print for CLI output
// ignore_for_file: avoid_print

// Publishes a clean, history-free snapshot of the current branch
// to the "public" remote's main branch.
//
// Usage:
//   dart run tool/publish.dart              # from current HEAD
//   dart run tool/publish.dart my-branch    # from a specific branch
import 'dart:io';

const publicRemote = 'public';
const publicBranch = 'main';

Future<void> main(List<String> args) async {
  final sourceRef = args.isEmpty ? 'HEAD' : args.first;

  final shortSha = await git(['rev-parse', '--short', sourceRef]);
  final date = DateTime.now().toIso8601String().split('T').first;
  final message = 'Release $date from $shortSha';

  print('==> Creating clean snapshot from $sourceRef');
  print('==> Target: $publicRemote/$publicBranch');
  print('');

  // Create a modified tree that excludes internal-only paths.
  final tree = await _treeWithout(
    sourceRef: sourceRef,
    exclude: ['tool'],
  );

  // Create an orphan commit with that tree
  final commit = await git(['commit-tree', tree, '-m', message]);

  print('==> Created orphan commit: $commit');
  print('==> Message: $message');
  print('');

  // Confirm before pushing
  stdout.write('Push to $publicRemote/$publicBranch? (y/N) ');
  final reply = stdin.readLineSync() ?? '';

  if (reply.toLowerCase() == 'y') {
    await git([
      'push',
      publicRemote,
      '$commit:refs/heads/$publicBranch',
      '--force',
    ]);
    print('==> Done. Published to $publicRemote/$publicBranch');
  } else {
    print('==> Aborted. Commit $commit was created locally but not pushed.');
    print(
      '    To push manually: git push $publicRemote '
      '$commit:refs/heads/$publicBranch --force',
    );
  }
}

/// Builds a new git tree from [sourceRef] with the given paths removed.
Future<String> _treeWithout({
  required String sourceRef,
  required List<String> exclude,
}) async {
  // Use a temporary index so we don't touch the working tree's index.
  final tmpIndex = '${Directory.systemTemp.path}/publish_index_$pid';
  final env = {'GIT_INDEX_FILE': tmpIndex};

  try {
    final sourceTree = await git(['rev-parse', '$sourceRef^{tree}']);
    await git(['read-tree', sourceTree], environment: env);
    for (final path in exclude) {
      await git(['rm', '-r', '--cached', '--quiet', path], environment: env);
    }
    return git(['write-tree'], environment: env);
  } finally {
    File(tmpIndex).deleteSync();
  }
}

Future<String> git(
  List<String> args, {
  Map<String, String>? environment,
}) async {
  final result = await Process.run(
    'git',
    args,
    environment: environment,
  );
  if (result.exitCode != 0) {
    stderr
      ..writeln('git ${args.join(' ')} failed:')
      ..writeln(result.stderr);
    exit(result.exitCode);
  }
  return (result.stdout as String).trim();
}
