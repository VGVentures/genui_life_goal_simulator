// Temporary preview file - delete after visual verification
// Run with: flutter run -t lib/main_preview.dart

import 'package:finance_app/app/presentation/app_colors.dart';
import 'package:finance_app/app/presentation/spacing.dart';
import 'package:finance_app/app/presentation/widgets/step_progress_indicator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const PreviewApp());
}

class PreviewApp extends StatelessWidget {
  const PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        extensions: [LightThemeColors()],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: [DarkThemeColors()],
      ),
      home: const PreviewPage(),
    );
  }
}

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  int currentStep = 1;
  final int totalSteps = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('StepProgressIndicator Preview'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step $currentStep of $totalSteps',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Spacing.lg),
            StepProgressIndicator(
              currentStep: currentStep,
              totalSteps: totalSteps,
              onNext: currentStep < totalSteps
                  ? () => setState(() => currentStep++)
                  : null,
            ),
            const SizedBox(height: Spacing.xxl),
            const Divider(),
            const SizedBox(height: Spacing.md),
            const Text('All states:'),
            const SizedBox(height: Spacing.md),
            // Step 1 of 3
            const Text('Step 1/3 (enabled)'),
            const SizedBox(height: Spacing.xs),
            StepProgressIndicator(
              currentStep: 1,
              totalSteps: 3,
              onNext: () {},
            ),
            const SizedBox(height: Spacing.md),
            // Step 2 of 3
            const Text('Step 2/3 (enabled)'),
            const SizedBox(height: Spacing.xs),
            StepProgressIndicator(
              currentStep: 2,
              totalSteps: 3,
              onNext: () {},
            ),
            const SizedBox(height: Spacing.md),
            // Step 3 of 3 (disabled)
            const Text('Step 3/3 (disabled - null callback)'),
            const SizedBox(height: Spacing.xs),
            const StepProgressIndicator(
              currentStep: 3,
              totalSteps: 3,
            ),
            const SizedBox(height: Spacing.xxl),
            ElevatedButton(
              onPressed: () => setState(() => currentStep = 1),
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
