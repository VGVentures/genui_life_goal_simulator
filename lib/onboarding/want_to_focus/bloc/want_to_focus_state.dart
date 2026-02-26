part of 'want_to_focus_cubit.dart';

final class WantToFocusState extends Equatable {
  const WantToFocusState({
    this.selectedOptions = const {},
    this.customOption = '',
  });

  final Set<FocusOption> selectedOptions;
  final String customOption;

  WantToFocusState copyWith({
    Set<FocusOption>? selectedOptions,
    String? customOption,
  }) {
    return WantToFocusState(
      selectedOptions: selectedOptions ?? this.selectedOptions,
      customOption: customOption ?? this.customOption,
    );
  }

  @override
  List<Object?> get props => [selectedOptions, customOption];
}
