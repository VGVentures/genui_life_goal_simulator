import 'package:bloc/bloc.dart';

part 'feature_flags_state.dart';

class FeatureFlagsCubit extends Cubit<FeatureFlagsState> {
  FeatureFlagsCubit() : super(FeatureFlagsState.initial());

  // TODO(juanRodriguez17): This will be change when the FeatureFlag
  //class gets integrated
  void onToggleFeatureFlag(String featureFlagId) {
    emit(state.copyWith(featureFlagId: featureFlagId));
  }
}
