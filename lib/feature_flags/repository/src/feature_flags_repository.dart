import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:vgv_genui_financial_advisor/feature_flags/repository/src/exceptions/feature_flags_exception.dart';
import 'package:vgv_genui_financial_advisor/feature_flags/repository/src/feature_flag.dart';

/// {@template feature_flags_repository}
/// A repository for managing feature flags, backed by
/// [StreamingSharedPreferences].
/// {@endtemplate}
class FeatureFlagsRepository {
  /// {@macro feature_flags_repository}
  const FeatureFlagsRepository({
    required StreamingSharedPreferences streamingSharedPreferences,
    required List<FeatureFlag> featureFlags,
  }) : _preferences = streamingSharedPreferences,
       _featureFlags = featureFlags;

  /// The [StreamingSharedPreferences] instance used to persist feature flag
  /// states.
  final StreamingSharedPreferences _preferences;

  /// The list of all known feature flags.
  final List<FeatureFlag> _featureFlags;

  /// SharedPreferences key prefix for feature flags.
  static const _keyPrefix = 'feature_flag_';

  /// Finds the [FeatureFlag] with the given [id].
  FeatureFlag _findFlag(String id) {
    return _featureFlags.firstWhere(
      (flag) => flag.id == id,
      orElse: () => throw FeatureFlagNotFoundException(id),
    );
  }

  /// Returns the IDs of all known feature flags.
  List<String> getFeatureFlagIds() {
    return _featureFlags.map((flag) => flag.id).toList();
  }

  /// Toggles the feature flag with the given [id] on or off.
  Future<void> toggleFeatureFlag(String id) async {
    final flag = _findFlag(id);
    final preference = _preferences.getBool(
      '$_keyPrefix$id',
      defaultValue: flag.defaultValue,
    );
    final currentValue = preference.getValue();
    await _preferences.setBool('$_keyPrefix$id', !currentValue);
  }

  /// Watches the feature flag with the given [id] for changes.
  ///
  /// Emits a [FeatureFlag] with the resolved [FeatureFlag.value]
  /// whenever the flag is toggled. If there is an override in shared
  /// preferences, that value is used; otherwise, [FeatureFlag.defaultValue]
  /// is returned.
  Stream<FeatureFlag> watchFeatureFlag(String id) {
    final flag = _findFlag(id);
    return _preferences
        .getBool('$_keyPrefix$id', defaultValue: flag.defaultValue)
        .map(
          (value) => FeatureFlag(
            id: flag.id,
            name: flag.name,
            description: flag.description,
            value: value,
            defaultValue: flag.defaultValue,
          ),
        );
  }
}
