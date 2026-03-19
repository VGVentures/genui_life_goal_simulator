/// {@template feature_flag}
/// A definition of a feature flag that can be toggled on and off.
/// {@endtemplate}
class FeatureFlag {
  /// {@macro feature_flag}
  const FeatureFlag({
    required this.id,
    required this.name,
    required this.description,
    required this.value,
    required this.defaultValue,
  });

  /// The unique identifier for this feature flag.
  final String id;

  /// The display name of this feature flag.
  final String name;

  /// A description of what this feature flag controls.
  final String description;

  /// The current resolved value of this feature flag (on/off).
  final bool value;

  /// The default value of this feature flag before any overrides.
  final bool defaultValue;
}
