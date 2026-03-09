import 'package:feature_flags_repository/feature_flags_repository.dart';
import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/dev_menu/dev_menu.dart';
import 'package:finance_app/feature_flag/bloc/feature_flags_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template dev_menu_drawer}
/// A debug drawer that displays all feature flags and allows toggling them.
/// {@endtemplate}
class DevMenuDrawer extends StatelessWidget {
  /// {@macro dev_menu_drawer}
  const DevMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => FeatureFlagsCubit(
        featureFlagsRepository: context.read<FeatureFlagsRepository>(),
      )..init(),
      child: Theme(
        data: AppThemes.light.themeData.getThemeData(context),
        child: Drawer(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Text(
                    'Dev Menu',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.black87),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: BlocBuilder<FeatureFlagsCubit, FeatureFlagsState>(
                    builder: (context, state) {
                      return switch (state) {
                        FeatureFlagsInitial() => const Center(
                          child: Text('Feature flags not initialized.'),
                        ),
                        FeatureFlagsInProgress() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        FeatureFlagsFailure(:final error) => Center(
                          child: Text('Error: $error'),
                        ),
                        FeatureFlagsSuccess(:final featureFlags) =>
                          _FeatureFlagList(featureFlags: featureFlags),
                      };
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.palette_outlined,
                    color: colors?.onSurface,
                  ),
                  title: Text(
                    'Design System',
                    style: textTheme.titleSmall,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colors?.onSurface,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const DesignSystemCatalogPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureFlagList extends StatelessWidget {
  const _FeatureFlagList({required this.featureFlags});

  final List<FeatureFlag> featureFlags;

  @override
  Widget build(BuildContext context) {
    if (featureFlags.isEmpty) {
      return const Center(child: Text('No feature flags defined.'));
    }

    return ListView.separated(
      itemCount: featureFlags.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final flag = featureFlags[index];
        return SwitchListTile(
          title: Text(
            flag.name,
            style: const TextStyle(color: Colors.black87),
          ),
          subtitle: Text(
            flag.description,
            style: const TextStyle(color: Colors.black54),
          ),
          activeThumbColor: Theme.of(context).colorScheme.primary,
          activeTrackColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.5),
          inactiveThumbColor: Colors.grey.shade400,
          inactiveTrackColor: Colors.grey.shade300,
          value: flag.value,
          onChanged: (_) async {
            await context.read<FeatureFlagsCubit>().onToggleFeatureFlag(
              flag.id,
            );
          },
        );
      },
    );
  }
}
