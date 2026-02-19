part of 'feature_flags_cubit.dart';

class FeatureFlagsState {
  FeatureFlagsState({
    required this.featureFlags,
    required this.isLoading,
    this.error,
  });

  factory FeatureFlagsState.initial() {
    return FeatureFlagsState(
      featureFlags: [],
      isLoading: false,
    );
  }

  final List<FeatureFlagState> featureFlags;
  bool isLoading;
  String? error;

  FeatureFlagsState copyWith({
    String? featureFlagId,
    List<FeatureFlagState>? featureFlags,
    bool? isLoading,
    String? error,
  }) {
    if (featureFlagId != null) {
      final index = this.featureFlags.indexWhere(
        (element) => element.featureFlag.id == featureFlagId,
      );

      if (index >= 0) {
        this.featureFlags[index] = FeatureFlagState(
          featureFlag: this.featureFlags[index].featureFlag,
          isEnabled: !this.featureFlags[index].isEnabled,
        );
      }
    }

    return FeatureFlagsState(
      featureFlags: featureFlags ?? this.featureFlags,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class FeatureFlagState {
  FeatureFlagState({
    required this.featureFlag,
    this.isEnabled = false,
  });

  final FeatureFlag featureFlag;
  final bool isEnabled;
}
