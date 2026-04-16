import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/items.dart';

/// The catalog ID for the finance catalog.
///
/// All components — both standard and custom finance widgets — are registered
/// under this single catalog. The LLM must use this exact value in
/// createSurface messages.
const financeCatalogId = 'com.vgv.finance_catalog';

/// Usage guidance appended to the system prompt so the LLM knows when and how
/// to use the finance-specific widgets beyond what the JSON schema describes.
const _financeWidgetRules = r'''
Use the AppButton widget to present clear calls-to-action.
- variant: "filled" for primary actions, "outlined" for secondary actions.
- size: "large" for prominent actions, "small" for inline or less prominent actions.
- isLoading: Set to true only when an async operation is in progress.
- For back navigation, use variant "outlined" with the exact action: {"event": {"name": "go_back"}}.

Use the EmojiCard widget to display categorized options or highlights as emoji-labelled cards in a responsive grid.

Use the LineChart widget to visualize trends over time (e.g. monthly spending, account balance history).

Use the BarChart widget to compare discrete values across multiple series and categories. Use 1–3 series and assign a distinct color to each. Always provide yAxisLabels ordered bottom to top.

Use the MetricCard widget to highlight key financial metrics (e.g. total spending, savings rate, net worth).

Use the RadioCard widget to present a set of mutually exclusive choices. CRITICAL: Every option MUST include "isSelected" — set exactly one to true and ALL others to false. Never omit isSelected on any option.

Use the FilterBar widget to let the user filter data by category. Include an "action" to refresh content when filters change. Example:
```openui
category_filter = FilterBar([{"label": "Food", "color": "pink", "isSelected": true}, {"label": "Transport", "color": "aqua", "isSelected": true}], {"event": {"name": "filter_changed"}})
```

IMPORTANT: When using FilterBar to filter charts or data, ALWAYS include an "action" so the LLM can regenerate content with the new filter selection.

Use the GCNSlider widget to let the user adjust a numeric value within a range. Provide value as a literal number or as $variable for binding. Set formatter to "usd", "percentage", or "integer". Set divisions and splitLabels for discrete steps.

Use the RankedTable widget to display items ranked from highest to lowest.

Use the ComparisonTable widget to compare spending between last month and this month by category.

Use the ActionItemsGroup widget to present a list of financial tasks, recommendations, or transaction highlights. Stack 2–10 items. Each item can have an optional "child" referencing a component ID (e.g. an AppButton) to render as a trailing widget. CRITICAL: the "child" button and the "title"/"subtitle"/"amount" fields MUST all belong to the SAME item entry.

CORRECT — button and content in the same item:
```openui
products = ActionItemsGroup({"items": [{"title": "Mortgage Pre-approval", "subtitle": "Lock in a rate.", "amount": "Required", "child": "view_rates_btn"}, {"title": "High-Yield Savings", "subtitle": "Best for your $70,000 fund.", "amount": "4.50% APY", "child": "top_picks_btn"}]})
view_rates_btn = AppButton("View Rates", "outlined", "small")
top_picks_btn = AppButton("Top Picks", "outlined", "small")
```

WRONG — never split a button into its own separate item.

Use the AppAccordion to display a group of related action items under a collapsible header. Set isExpanded to true only when urgent.

Use the CategoryFilterChip widget to display a toggleable filter chip. Set isSelected to true for selected state. Include an "action" to refresh content when toggled.

Use SectionHeader to label a section with a title and subtitle. Optionally include selectorOptions for time period switching. Include a selectorAction to refresh content when changed. Example:
```openui
spending_header = SectionHeader("Your Spending", "February 2026", ["1M", "3M", "6M"], 0, {"event": {"name": "period_changed"}})
```

IMPORTANT: On the summary screen, ALWAYS include a SectionHeader with selectorOptions AND selectorAction when displaying time-based data.

Use HeaderSelector as a standalone component for chip-style toggles without a section header. Example:
```openui
period_selector = HeaderSelector(["1M", "3M", "6M"], 0, {"event": {"name": "period_changed"}})
```

Use HorizontalBar to compare spending categories against a prior period or benchmark. Use ProgressBar instead when the reference is a fixed budget limit.

Use ProgressBar to show spending categories vs. a fixed budget limit.

Use the SparklineCard widget to display financial categories with amounts and trend sparklines. Always provide at least 2 cards. Set trend to "positive", "negative", or "stable".

Use PieChart for part-to-whole relationships. Provide 3–7 segments with distinct colors. Always set totalLabel and totalAmount.

Use the TransactionList widget to display recent transactions. Optionally include an "action" on each item for a View button.

Use the InsightCard widget for key contextual insights — place directly inside SummaryContainer, never inside SectionCard.
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
          insightCardItem,
          gcnSliderItem,
          barChartItem,
          lineChartItem,
          nextStepsBarItem,
          pieChartItem,
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
