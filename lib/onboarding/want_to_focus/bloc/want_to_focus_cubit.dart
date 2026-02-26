import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';

part 'want_to_focus_state.dart';

class WantToFocusCubit extends Cubit<WantToFocusState> {
  WantToFocusCubit() : super(const WantToFocusState());

  void toggleOption(FocusOption option) {
    final selected = Set<FocusOption>.from(state.selectedOptions);
    if (selected.contains(option)) {
      selected.remove(option);
    } else {
      selected.add(option);
    }
    emit(state.copyWith(selectedOptions: selected));
  }

  void setCustomOption(String text) {
    emit(state.copyWith(customOption: text));
  }
}
