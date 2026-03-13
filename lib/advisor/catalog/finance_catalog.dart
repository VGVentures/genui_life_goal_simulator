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

Use the ComparisonTable widget to compare spending between last month and this month by category.
''';

/// Builds the full catalog of financial widgets for GenUI.
Catalog buildFinanceCatalog() {
  return BasicCatalogItems.asCatalog().copyWith(
    catalogId: financeCatalogId,
    newItems: [
      appButtonItem,
      comparisonTableItem,
      emojiCardItem,
      filterBarItem,
      gcnSliderItem,
      lineChartItem,
      metricCardsItem,
      radioCardItem,
    ],
    systemPromptFragments: [_financeWidgetRules],
  );
}
