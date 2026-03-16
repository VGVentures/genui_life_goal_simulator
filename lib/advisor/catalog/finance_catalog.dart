import 'package:finance_app/advisor/catalog/items/items.dart';
import 'package:genui/genui.dart';

/// The catalog ID for the finance catalog.
///
/// All components — both standard and custom finance widgets — are registered
/// under this single catalog. The LLM must use this exact value in
/// createSurface messages.
const financeCatalogId = 'com.vgv.finance_catalog';

/// Usage guidance appended to the system prompt so the LLM knows when and how
/// to use the finance-specific widgets beyond what the JSON schema describes.
const _financeWidgetRules =
    '''
IMPORTANT: Every A2UI JSON message MUST include "version": "v0.9" at the top level, and when creating a surface you MUST use this exact catalogId: "$financeCatalogId". Do NOT invent or guess a different catalogId.

Example createSurface:
```json
{
  "version": "v0.9",
  "createSurface": {
    "surfaceId": "unique_id",
    "catalogId": "$financeCatalogId",
    "sendDataModel": true
  }
}
```

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

Use the RankedTable widget to display items ranked from highest to lowest (e.g. top merchants by spend, biggest expense categories). Each item shows a rank number, title, amount, and percentage delta. Positive deltas appear green, negative deltas appear red.

Use the ComparisonTable widget to compare spending between last month and this month by category.

Use the ActionItemsGroup widget to present a list of financial tasks, recommendations, or transaction highlights (e.g. spending categories, debt steps). Stack 2–10 items. Each item can have an optional "child" referencing a component ID (e.g. an AppButton) to render as a trailing widget for per-item actions.

Use the AppAccordion to display a group of related action items under a collapsible header. Set isExpanded to true only when the content is urgent or the user explicitly asked for it. Each item can have an optional "child" referencing a component ID (e.g. an AppButton) for per-item actions.

Use the CategoryFilterChip widget to display a toggleable filter chip for category selection (e.g. spending categories or tags). Set isSelected to true to show it in its selected state. Set isEnabled to false to render it in a disabled/muted state.

Use SectionHeader to label a section with a title and subtitle. Optionally include selectorOptions to show a HeaderSelector alongside the title for time period switching (e.g. title: "Your spending this month", subtitle: "February 2026 • 19 days tracked", selectorOptions: ["1M", "3M", "6M"], selectedIndex: 0).

Use HeaderSelector to show chip-style toggles for switching between views or time periods (e.g. ["1M", "3M", "6M"]). Set selectedIndex to highlight the currently relevant option.

Use HorizontalBar to compare spending categories against a prior period or external benchmark (e.g. last month, category average). Set progress as actual ÷ reference. Use ProgressBar instead when the reference is a fixed budget limit.

Use ProgressBar to show spending categories vs. a fixed budget limit. Set value to actual spend and total to the budget. Do not use when the reference is a prior period — use HorizontalBar instead.

Use the SparklineCard widget to display a financial category with its amount and a trend sparkline. Set trend to "positive" (green) for growing values, "negative" (red) for declining values, or "stable" (blue) for flat trends.

Use the TransactionList widget to display a list of recent transactions. Each item shows a title (merchant name), description (category), and formatted amount.
''';

/// Builds the full catalog of financial widgets for GenUI.
Catalog buildFinanceCatalog() {
  return BasicCatalogItems.asCatalog()
      .copyWithout(
        itemsToRemove: [
          BasicCatalogItems.audioPlayer,
          BasicCatalogItems.button,
          BasicCatalogItems.card,
          BasicCatalogItems.checkBox,
          BasicCatalogItems.choicePicker,
          BasicCatalogItems.dateTimeInput,
          BasicCatalogItems.divider,
          BasicCatalogItems.icon,
          BasicCatalogItems.image,
          BasicCatalogItems.list,
          BasicCatalogItems.modal,
          BasicCatalogItems.slider,
          BasicCatalogItems.tabs,
          BasicCatalogItems.textField,
          BasicCatalogItems.video,
        ],
      )
      .copyWith(
        catalogId: financeCatalogId,
        newItems: [
          actionItemsGroupItem,
          aiButtonItem,
          headerSelectorItem,
          sectionHeaderItem,
          accordionItem,
          appButtonItem,
          categoryFilterChipItem,
          comparisonTableItem,
          emojiCardItem,
          filterBarItem,
          horizontalBarItem,
          gcnSliderItem,
          lineChartItem,
          nextStepsBarItem,
          progressBarItem,
          questionContainerItem,
          metricCardsItem,
          radioCardItem,
          rankedTableItem,
          sectionCardItem,
          sparklineCardItem,
          summaryContainerItem,
          transactionListItem,
        ],
        systemPromptFragments: [_financeWidgetRules],
      );
}
