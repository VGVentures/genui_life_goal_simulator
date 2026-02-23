import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feature_flags_repository/feature_flags_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'feature_flags_state.dart';

class FeatureFlagsCubit extends Cubit<FeatureFlagsState> {
  FeatureFlagsCubit({required FeatureFlagsRepository featureFlagsRepository})
    : _featureFlagsRepository = featureFlagsRepository,
      super(const FeatureFlagsInitial());

  final FeatureFlagsRepository _featureFlagsRepository;
  StreamSubscription<List<FeatureFlag>>? _featureFlagSubscription;

  @override
  Future<void> close() async {
    await _featureFlagSubscription?.cancel();
    return super.close();
  }

  void init() {
    emit(const FeatureFlagsInProgress());

    try {
      final featureFlags = _featureFlagsRepository.getFeatureFlagIds();
      final featureFlagsStream = Rx.combineLatestList<FeatureFlag>([
        for (final id in featureFlags)
          _featureFlagsRepository.watchFeatureFlag(id),
      ]);

      _featureFlagSubscription = featureFlagsStream.listen(
        (featureFlags) => emit(FeatureFlagsSuccess(featureFlags: featureFlags)),
        onError: (Object error) => emit(FeatureFlagsFailure(error: error)),
      );
    } on Object catch (error) {
      emit(FeatureFlagsFailure(error: error));
    }
  }

  /// Toggles the feature flag with the given [id] on or off.
  Future<void> onToggleFeatureFlag(String id) {
    return _featureFlagsRepository.toggleFeatureFlag(id);
  }
}
