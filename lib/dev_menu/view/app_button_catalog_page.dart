import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template app_button_catalog_page}
/// Catalog page showcasing all [AppButton] variants and sizes.
/// {@endtemplate}
class AppButtonCatalogPage extends StatelessWidget {
  /// {@macro app_button_catalog_page}
  const AppButtonCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('AppButton')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('Filled – Large'),
            AppButton(label: 'Continue', onPressed: () {}),
            const SizedBox(height: Spacing.md),
            const _SectionLabel('Filled – Small'),
            AppButton(
              label: 'Continue',
              size: AppButtonSize.small,
              onPressed: () {},
            ),
            const SizedBox(height: Spacing.md),
            const _SectionLabel('Outlined – Large'),
            AppButton(
              label: 'Cancel',
              variant: AppButtonVariant.outlined,
              onPressed: () {},
            ),
            const SizedBox(height: Spacing.md),
            const _SectionLabel('Outlined – Small'),
            AppButton(
              label: 'Cancel',
              variant: AppButtonVariant.outlined,
              size: AppButtonSize.small,
              onPressed: () {},
            ),
            const SizedBox(height: Spacing.md),
            const _SectionLabel('With leading icon'),
            AppButton(
              label: 'Add',
              leadingIcon: const Icon(Icons.add, size: 18),
              onPressed: () {},
            ),
            const SizedBox(height: Spacing.md),
            const _SectionLabel('With trailing icon'),
            AppButton(
              label: 'Next',
              trailingIcon: const Icon(Icons.arrow_forward, size: 18),
              onPressed: () {},
            ),
            const SizedBox(height: Spacing.md),
            const _SectionLabel('Disabled – Filled'),
            const AppButton(label: 'Disabled'),
            const SizedBox(height: Spacing.md),
            const _SectionLabel('Disabled – Outlined'),
            const AppButton(
              label: 'Disabled',
              variant: AppButtonVariant.outlined,
            ),
            const SizedBox(height: Spacing.md),
            const _SectionLabel('Loading – Filled'),
            const AppButton(label: 'Submit', isLoading: true),
            const SizedBox(height: Spacing.md),
            const _SectionLabel('Loading – Outlined'),
            const AppButton(
              label: 'Submit',
              variant: AppButtonVariant.outlined,
              isLoading: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.xs),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).extension<AppColors>()?.onSurfaceMuted,
        ),
      ),
    );
  }
}
