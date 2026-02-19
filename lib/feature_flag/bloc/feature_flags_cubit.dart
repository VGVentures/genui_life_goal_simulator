import 'package:bloc/bloc.dart';
import 'package:feature_flags_repository/feature_flags_repository.dart';

part 'feature_flags_state.dart';

class FeatureFlagsCubit extends Cubit<FeatureFlagsState> {
  FeatureFlagsCubit() : super(FeatureFlagsState.initial());

  /// Toggles the feature flag with the given [id] on or off.
  void onToggleFeatureFlag(String id) {
    emit(state.copyWith(featureFlagId: id));
  }
}
