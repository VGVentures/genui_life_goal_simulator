import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';

part 'pick_profile_state.dart';

class PickProfileCubit extends Cubit<PickProfileState> {
  PickProfileCubit() : super(const PickProfileState());

  void selectProfile(ProfileType profile) {
    emit(PickProfileState(selectedProfile: profile));
  }
}
