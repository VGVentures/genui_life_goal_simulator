part of 'feature_flags_cubit.dart';

sealed class FeatureFlagsState {
  const FeatureFlagsState();
}

class FeatureFlagsInitial extends FeatureFlagsState {
  const FeatureFlagsInitial();
}

class FeatureFlagsInProgress extends FeatureFlagsState {
  const FeatureFlagsInProgress();
}

class FeatureFlagsSuccess extends Equatable implements FeatureFlagsState {
  const FeatureFlagsSuccess({required this.featureFlags});

  final List<FeatureFlag> featureFlags;

  @override
  List<Object?> get props => [featureFlags];
}

class FeatureFlagsFailure extends Equatable implements FeatureFlagsState {
  const FeatureFlagsFailure({required this.error});

  final Object error;

  @override
  List<Object?> get props => [error];
}
