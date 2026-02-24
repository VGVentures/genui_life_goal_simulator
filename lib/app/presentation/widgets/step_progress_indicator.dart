import 'package:finance_app/app/presentation/app_colors.dart';
import 'package:finance_app/app/presentation/spacing.dart';
import 'package:flutter/material.dart';

/// A horizontal progress indicator with a Next button for step-based flows.
///
/// Displays a progress bar showing the current step out of total steps,
/// with a Next button that triggers the [onNext] callback when pressed.
class StepProgressIndicator extends StatelessWidget {
  const StepProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
    this.onNext,
    super.key,
  }) : assert(totalSteps > 0, 'totalSteps must be greater than 0'),
       assert(
         currentStep >= 1 && currentStep <= totalSteps,
         'currentStep must be between 1 and totalSteps',
       );

  final int currentStep;
  final int totalSteps;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(child: _ProgressBar(progress: currentStep / totalSteps)),
          const SizedBox(width: Spacing.md),
          _NextButton(onPressed: onNext),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  static const double _barHeight = 5;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      height: _barHeight,
      decoration: BoxDecoration(
        color: colors.neutral.shade50,
        borderRadius: BorderRadius.circular(_barHeight / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Container(
                width: constraints.maxWidth * progress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.accent.shade500,
                      colors.accent.shade300,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(_barHeight / 2),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            onPressed != null ? colors.buttonPrimary : colors.neutral.shade200,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.xxxl,
          vertical: Spacing.sm,
        ),
        elevation: 0,
      ),
      child: const Text(
        'Next',
        style: TextStyle(fontSize: 10),
      ),
    );
  }
}
