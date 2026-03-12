import 'package:finance_app/advisor/catalog/items/items.dart';
import 'package:genui/genui.dart';

/// Builds the full catalog of financial widgets for GenUI.
Catalog buildFinanceCatalog() {
  return BasicCatalogItems.asCatalog().copyWith(
    newItems: [userSummaryCardItem],
  );
}
