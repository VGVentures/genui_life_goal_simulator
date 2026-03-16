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

  // Create a fresh tree object from the source ref (no history)
  final tree = await git(['rev-parse', '$sourceRef^{tree}']);

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

Future<String> git(List<String> args) async {
  final result = await Process.run('git', args);
  if (result.exitCode != 0) {
    stderr
      ..writeln('git ${args.join(' ')} failed:')
      ..writeln(result.stderr);
    exit(result.exitCode);
  }
  return (result.stdout as String).trim();
}
