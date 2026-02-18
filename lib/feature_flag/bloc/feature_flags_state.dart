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
    // TODO(juanRodriguez17): Use the class that is on FeatureFlagRepository PR
    String? featureFlagId,
    List<FeatureFlagState>? featureFlags,
    bool? isLoading,
    String? error,
  }) {
    if (featureFlagId != null) {
      final index = this.featureFlags.indexWhere(
        // TODO(juanRodriguez17): element.featureFlag.id == featureFlagId
        (element) => element.featureFlag == featureFlagId,
      );

      if (index >= 0) {
        this.featureFlags[index] = FeatureFlagState(
          featureFlag: this.featureFlags[index].featureFlag,
          isEnabled: !this.featureFlags[index].isEnabled,
        );
      }
    }

    // TODO(juanRodriguez17): Modify featureFlags operations when gets integrated
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

  // TODO(juanRodriguez17): Use the class that is on FeatureFlagRepository PR
  // final FeatureFlag featureFlag;
  final String featureFlag;
  final bool isEnabled;
}
