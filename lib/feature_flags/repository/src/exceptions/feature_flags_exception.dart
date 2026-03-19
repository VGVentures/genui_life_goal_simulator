/// {@template feature_flags_exception}
/// Base exception class for feature flag-related errors.
/// {@endtemplate}
class FeatureFlagsException implements Exception {
  /// {@macro feature_flags_exception}
  const FeatureFlagsException(this.message);

  /// The error message describing what went wrong.
  final String message;

  @override
  String toString() => 'FeatureFlagsException: $message';
}

/// {@template feature_flag_not_found_exception}
/// Exception thrown when a feature flag with a given ID is not found.
/// {@endtemplate}
class FeatureFlagNotFoundException extends FeatureFlagsException {
  /// {@macro feature_flag_not_found_exception}
  const FeatureFlagNotFoundException(this.id)
    : super('No feature flag found with id "$id".');

  /// The feature flag ID that was not found.
  final String id;
}
