import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template sample_dashboard_page}
/// An offline, hand-composed finance dashboard built from the reskinned
/// design-system widgets with fixed sample data.
///
/// The live simulator composes this kind of dashboard from the AI model at
/// runtime, which needs a Firebase AI backend. This page needs none, so it is
/// the fastest way to review the GenUI Kit reskin in a realistic layout — every
/// widget here reads the same [AppColors] tokens the real surfaces do, so it
/// tracks light and dark. It is reachable only from the dev menu.
/// {@endtemplate}
class SampleDashboardPage extends StatefulWidget {
  /// {@macro sample_dashboard_page}
  const SampleDashboardPage({super.key});

  @override
  State<SampleDashboardPage> createState() => _SampleDashboardPageState();
}

class _SampleDashboardPageState extends State<SampleDashboardPage> {
  int _period = 0;
  int _selectedSlice = 0;
  final Set<int> _activeCategories = {0, 1, 2, 3, 4};

  static const List<({String label, FilterChipColor color})> _categories = [
    (label: 'Groceries', color: FilterChipColor.emerald),
    (label: 'Dining', color: FilterChipColor.orange),
    (label: 'Transport', color: FilterChipColor.plum),
    (label: 'Shopping', color: FilterChipColor.mustard),
    (label: 'Travel', color: FilterChipColor.lightBlue),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;

    final pieItems = [
      PieChartItem(
        label: 'Groceries',
        value: 1180,
        amount: r'$1,180',
        color: colors?.emeraldColor,
      ),
      PieChartItem(
        label: 'Dining',
        value: 640,
        amount: r'$640',
        color: colors?.orangeColor,
      ),
      PieChartItem(
        label: 'Transport',
        value: 410,
        amount: r'$410',
        color: colors?.plumColor,
      ),
      PieChartItem(
        label: 'Shopping',
        value: 520,
        amount: r'$520',
        color: colors?.mustardColor,
      ),
      PieChartItem(
        label: 'Travel',
        value: 475,
        amount: r'$475',
        color: colors?.lightBlueColor,
      ),
    ];

    return Scaffold(
      backgroundColor: colors?.surface,
      appBar: AppBar(title: const Text('Sample Dashboard (offline)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Good morning, Alex',
                  style: textTheme.displaySmall?.copyWith(
                    color: colors?.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  'Home · buying a house in ~2 years',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors?.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Spacing.xl),

                // Spending overview: header with period selector + metrics.
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeader(
                        title: 'Your spending',
                        subtitle: 'February 2026 · 19 days tracked',
                        selectorOptions: const ['1M', '3M', '6M'],
                        selectedIndex: _period,
                        onSelectorChanged: (i) =>
                            setState(() => _period = i),
                      ),
                      const SizedBox(height: Spacing.lg),
                      const MetricCardsLayout(
                        cards: [
                          MetricCard(
                            label: 'Total spent',
                            value: r'$3,225',
                            delta: '8%',
                            deltaDirection: MetricDeltaDirection.negative,
                            subtitle: 'vs last month',
                          ),
                          MetricCard(
                            label: 'Savings rate',
                            value: '22%',
                            delta: '3%',
                            deltaDirection: MetricDeltaDirection.positive,
                            subtitle: 'above 20% target',
                          ),
                          MetricCard(
                            label: 'Toward down payment',
                            value: r'$1,050',
                            subtitle: r'of $1,200 monthly goal',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.md),

                // Category breakdown: donut + category filter chips.
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SectionHeader(
                        title: 'Where your money went',
                        subtitle: 'Tap a category to focus it',
                      ),
                      const SizedBox(height: Spacing.lg),
                      PieChartComponent(
                        items: pieItems,
                        totalLabel: 'Total',
                        totalAmount: r'$3,225',
                        selectedIndex: _selectedSlice,
                      ),
                      const SizedBox(height: Spacing.lg),
                      Wrap(
                        spacing: Spacing.xs,
                        runSpacing: Spacing.xs,
                        children: [
                          for (var i = 0; i < _categories.length; i++)
                            CategoryFilterChip(
                              color: _categories[i].color,
                              label: _categories[i].label,
                              isSelected: _activeCategories.contains(i),
                              onTap: () => setState(() {
                                _selectedSlice = i;
                                if (!_activeCategories.add(i)) {
                                  _activeCategories.remove(i);
                                }
                              }),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.md),

                // Category trends row (sparklines).
                const _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeader(
                        title: 'Category trends',
                        subtitle: 'Last 3 months',
                      ),
                      SizedBox(height: Spacing.lg),
                      SparklineCardsLayout(
                        cards: [
                          SparklineCard(
                            label: 'Groceries',
                            amount: r'$1,180',
                            trend: TrendType.positive,
                          ),
                          SparklineCard(
                            label: 'Dining',
                            amount: r'$640',
                            trend: TrendType.negative,
                          ),
                          SparklineCard(
                            label: 'Transport',
                            amount: r'$410',
                            trend: TrendType.stable,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.md),

                // Insights.
                const InsightCard(
                  title: "You're on track",
                  description:
                      'Your savings rate is 22%, above the recommended 20% '
                      'benchmark for your down-payment timeline.',
                  variant: InsightCardVariant.success,
                ),
                const SizedBox(height: Spacing.md),
                const InsightCard(
                  title: 'Dining is trending up',
                  description:
                      'Dining out is 34% higher than your 3-month average. '
                      r'Trimming it $150/mo keeps you on pace.',
                  variant: InsightCardVariant.warning,
                ),
                const SizedBox(height: Spacing.md),

                // Recommended actions.
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SectionHeader(
                        title: 'Recommended next steps',
                        subtitle: 'Based on your goals',
                      ),
                      const SizedBox(height: Spacing.sm),
                      ActionItemsGroup(
                        items: [
                          ActionItem(
                            title: r'Move $150/mo to your house fund',
                            subtitle: 'High-yield savings · 4.50% APY',
                            amount: 'Suggested',
                            trailing: AppButton(
                              label: 'Set up',
                              size: AppButtonSize.small,
                              onPressed: () {},
                            ),
                          ),
                          ActionItem(
                            title: 'Review 3 recurring subscriptions',
                            subtitle: r'Streaming · $47/mo total',
                            amount: r'$47',
                            trailing: AppButton(
                              label: 'Review',
                              variant: AppButtonVariant.outlined,
                              size: AppButtonSize.small,
                              onPressed: () {},
                            ),
                          ),
                          const ActionItem(
                            title: 'Mortgage pre-approval',
                            subtitle: 'Lock a rate and confirm your budget',
                            amount: 'Later',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xl),

                AppButton(
                  label: 'Ask the advisor',
                  variant: AppButtonVariant.gradient,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A rounded surface card matching the reskinned dashboard container.
class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: colors?.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors?.outlineVariant ?? Colors.transparent),
      ),
      child: child,
    );
  }
}
