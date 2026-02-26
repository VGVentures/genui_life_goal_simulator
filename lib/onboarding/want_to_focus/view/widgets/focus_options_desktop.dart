import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/want_to_focus/want_to_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FocusOptionsDesktop extends StatelessWidget {
  const FocusOptionsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<WantToFocusCubit, WantToFocusState>(
      builder: (context, state) {
        return Row(
          spacing: Spacing.xl,
          children: [
            Expanded(
              child: Column(
                spacing: _Dimensions.columnSpacing,
                children: [
                  SelectableOptionCard(
                    label: l10n.everydaySpendingLabel,
                    isSelected: state.selectedOptions.contains(
                      FocusOption.everydaySpending,
                    ),
                    onTap: () => context.read<WantToFocusCubit>().toggleOption(
                      FocusOption.everydaySpending,
                    ),
                  ),
                  SelectableOptionCard(
                    label: l10n.saveForRetirementLabel,
                    isSelected: state.selectedOptions.contains(
                      FocusOption.saveForRetirement,
                    ),
                    onTap: () => context.read<WantToFocusCubit>().toggleOption(
                      FocusOption.saveForRetirement,
                    ),
                  ),
                  SelectableOptionCard(
                    label: l10n.mortgageLabel,
                    isSelected: state.selectedOptions.contains(
                      FocusOption.mortgage,
                    ),
                    onTap: () => context.read<WantToFocusCubit>().toggleOption(
                      FocusOption.mortgage,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: _Dimensions.columnSpacing,
                children: [
                  SelectableOptionCard(
                    label: l10n.housingAndFixedCostsLabel,
                    isSelected: state.selectedOptions.contains(
                      FocusOption.housingAndFixedCosts,
                    ),
                    onTap: () => context.read<WantToFocusCubit>().toggleOption(
                      FocusOption.housingAndFixedCosts,
                    ),
                  ),
                  SelectableOptionCard(
                    label: l10n.healthcareAndInsuranceLabel,
                    isSelected: state.selectedOptions.contains(
                      FocusOption.healthcareAndInsurance,
                    ),
                    onTap: () => context.read<WantToFocusCubit>().toggleOption(
                      FocusOption.healthcareAndInsurance,
                    ),
                  ),
                  WriteYourOwnOptionCard(
                    label: l10n.writeYourOwnLabel,
                    onChanged: (text) =>
                        context.read<WantToFocusCubit>().setCustomOption(text),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

abstract final class _Dimensions {
  static const double columnSpacing = 26;
}
