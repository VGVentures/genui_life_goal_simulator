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
- For back navigation, use variant "outlined" with the exact action: {"event": {"name": "go_back"}}.

Use the EmojiCard widget to display a set of categorized options or highlights as emoji-labelled cards in a responsive grid.

Use the LineChart widget to visualize trends over time (e.g. monthly spending, account balance history).

Use the BarChart widget to compare discrete values across multiple series and categories (e.g. monthly spending by account, budget vs. actual by category). Use 1–3 series and assign a distinct color to each. Always provide yAxisLabels ordered bottom to top.

Use the MetricCard widget to highlight key financial metrics (e.g. total spending, savings rate, net worth).

Use the RadioCard widget to present a set of mutually exclusive choices (e.g. profile type, plan selection). Exactly one option should have isSelected: true.

Use the FilterBar widget to let the user filter data by category (e.g. spending categories, account types). Include an "action" to refresh content when filters change. Example:
{"id": "category_filter", "component": "FilterBar", "categories": [{"label": "Food", "color": "pink", "isSelected": true}, {"label": "Transport", "color": "aqua", "isSelected": true}], "action": {"event": {"name": "filter_changed"}}}

IMPORTANT: When using FilterBar to filter charts or data, ALWAYS include an "action" so the LLM can regenerate content with the new filter selection.

Use the GCNSlider widget to let the user adjust a numeric value within a range (e.g. budget limit, spending target). Provide `value` as a literal number or as {"path": "/..."} when sharing state across components. Set `formatter` to control the value label: "usd" for dollar amounts, "percentage" for percents, "integer" for plain numbers. Set divisions and splitLabels for discrete steps.

Use the RankedTable widget to display items ranked from highest to lowest (e.g. top merchants by spend, biggest expense categories). Each item shows a rank number, title, amount, and percentage delta. Positive deltas appear green, negative deltas appear red.

Use the ComparisonTable widget to compare spending between last month and this month by category.

Use the ActionItemsGroup widget to present a list of financial tasks, recommendations, or transaction highlights (e.g. spending categories, debt steps). Stack 2–10 items. Each item can have an optional "child" referencing a component ID (e.g. an AppButton) to render as a trailing widget alongside the item's title, subtitle, and amount — all in the same row. CRITICAL: the "child" button and the "title"/"subtitle"/"amount" fields MUST all belong to the SAME item entry. Never create a separate item just for a button.

CORRECT — button and content in the same item:
```json
{"id": "products", "component": "ActionItemsGroup", "data": {"items": [
  {"title": "Mortgage Pre-approval", "subtitle": "Lock in a rate and confirm your buying power.", "amount": "Required", "child": "view_rates_btn"},
  {"title": "High-Yield Savings Account", "subtitle": "Best for your \$70,000 down payment fund.", "amount": "4.50% APY", "child": "top_picks_btn"}
]}},
{"id": "view_rates_btn", "component": "AppButton", "label": "View Rates", "variant": "outlined", "size": "small"},
{"id": "top_picks_btn", "component": "AppButton", "label": "Top Picks", "variant": "outlined", "size": "small"}
```

WRONG — never split a button into its own separate item:
```json
{"id": "products", "component": "ActionItemsGroup", "data": {"items": [
  {"title": "", "subtitle": "", "amount": "", "child": "view_rates_btn"},
  {"title": "Mortgage Pre-approval", "subtitle": "Lock in a rate...", "amount": "Required"}
]}}
```

Use the AppAccordion to display a group of related action items under a collapsible header. Set isExpanded to true only when the content is urgent or the user explicitly asked for it. Each item can have an optional "child" referencing a component ID (e.g. an AppButton) for per-item actions.

Use the CategoryFilterChip widget to display a toggleable filter chip for category selection (e.g. spending categories or tags). Set isSelected to true to show it in its selected state. Set isEnabled to false to render it in a disabled/muted state. Include an "action" to refresh content when toggled.

Use SectionHeader to label a section with a title and subtitle. Optionally include selectorOptions to show a HeaderSelector alongside the title for time period switching. The selected option is written to the data model at "/<componentId>/selectedOption". Include a "selectorAction" to automatically refresh content when the user changes the selection. Example:
{"id": "spending_header", "component": "SectionHeader", "title": "Your Spending", "subtitle": "February 2026", "selectorOptions": ["1M", "3M", "6M"], "selectedIndex": 0, "selectorAction": {"event": {"name": "period_changed"}}}

IMPORTANT: On the summary screen, ALWAYS include a SectionHeader with selectorOptions AND selectorAction when displaying time-based data (charts, metrics, spending breakdowns). This lets users switch between time periods (e.g. "1M", "3M", "6M", "1Y") and immediately see updated data. Place the SectionHeader at the top of each SectionCard that contains time-sensitive content.

Use HeaderSelector as a standalone component when you need chip-style toggles without a section header (e.g. inside a card or inline with other content). Set options to the list of labels and selectedIndex to highlight the current selection. The selected option is written to "/<componentId>/selectedOption". Include an "action" to refresh content when the selection changes. Example:
{"id": "period_selector", "component": "HeaderSelector", "options": ["1M", "3M", "6M"], "selectedIndex": 0, "action": {"event": {"name": "period_changed"}}}

Use HorizontalBar to compare spending categories against a prior period or external benchmark (e.g. last month, category average). Set progress as actual ÷ reference. Use ProgressBar instead when the reference is a fixed budget limit.

Use ProgressBar to show spending categories vs. a fixed budget limit. Set value to actual spend and total to the budget. Do not use when the reference is a prior period — use HorizontalBar instead.

Use the SparklineCard widget to display financial categories, each with an amount and a trend sparkline — arranged in a horizontal row on desktop or stacked vertically on mobile. Always provide at least 2 cards in the "cards" array. Set trend to "positive" (green) for growing values, "negative" (red) for declining values, or "stable" (blue) for flat trends.

Use PieChart when showing part-to-whole relationships (e.g. spending by category, portfolio allocation). Provide 3–7 segments and assign a distinct color to each. Always set totalLabel and totalAmount to show the aggregate in the donut center.

Use the TransactionList widget to display a list of recent transactions. Each item shows a title (merchant name), description (category), and formatted amount. Optionally include an "action" on each item to show a View button — when tapped, it dispatches the specified event with the item's data as context.

Use the InsightCard widget to highlight a key contextual insight alongside financial data — place it directly inside a SummaryContainer layout, never inside a QuestionContainer. CRITICAL: never wrap InsightCard in a SectionCard; it has its own card styling and must render without any white container around it.
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
