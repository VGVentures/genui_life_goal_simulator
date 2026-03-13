import 'package:finance_app/advisor/catalog/items/items.dart';
import 'package:genui/genui.dart';

/// Usage guidance appended to the system prompt so the LLM knows when and how
/// to use the finance-specific widgets beyond what the JSON schema describes.
const _financeWidgetRules = '''
When populating the UserSummaryCard, ask the user for the information you need to populate the card, or provide reasonable example values and invite the user to correct them.

Use the AppButton widget to present clear calls-to-action, such as navigating to a detailed view, confirming a choice, or starting a workflow.
- variant: "filled" for primary actions, "outlined" for secondary actions.
- size: "large" for prominent actions, "small" for inline or less prominent actions.
- isLoading: Set to true only when an async operation is in progress.

Use the EmojiCard widget to display a set of categorized options or highlights as emoji-labelled cards in a responsive grid.

Use the LineChart widget to visualize trends over time (e.g. monthly spending, account balance history).

Use the MetricCard widget to highlight key financial metrics (e.g. total spending, savings rate, net worth).

Use the RadioCard widget to present a set of mutually exclusive choices (e.g. profile type, plan selection). Exactly one option should have isSelected: true.

Use the FilterBar widget to let the user filter data by category (e.g. spending categories, account types).

Use the GCNSlider widget to let the user adjust a numeric value within a range (e.g. budget limit, spending target). Set divisions and splitLabels for discrete steps.

Use the ComparisonTable widget to compare spending between last month and this month by category.

Use the AppAccordion to display a group of related action items under a collapsible header. Set isExpanded to true only when the content is urgent or the user explicitly asked for it.

Use the CategoryFilterChip widget to display a toggleable filter chip for category selection (e.g. spending categories or tags). Set isSelected to true to show it in its selected state. Set isEnabled to false to render it in a disabled/muted state.

Use HorizontalBar to compare spending categories against a prior period or external benchmark (e.g. last month, category average). Set progress as actual ÷ reference. Use ProgressBar instead when the reference is a fixed budget limit.

Use ProgressBar to show spending categories vs. a fixed budget limit. Set value to actual spend and total to the budget. Do not use when the reference is a prior period — use HorizontalBar instead.
''';

/// Builds the full catalog of financial widgets for GenUI.
Catalog buildFinanceCatalog() {
  return BasicCatalogItems.asCatalog().copyWith(
    newItems: [
      accordionItem,
      appButtonItem,
      categoryFilterChipItem,
      comparisonTableItem,
      emojiCardItem,
      filterBarItem,
      horizontalBarItem,
      gcnSliderItem,
      lineChartItem,
      progressBarItem,
      metricCardsItem,
      radioCardItem,
      userSummaryCardItem,
    ],
    systemPromptFragments: [_financeWidgetRules],
  );
}
