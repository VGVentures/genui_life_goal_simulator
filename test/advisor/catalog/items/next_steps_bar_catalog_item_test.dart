import 'package:finance_app/advisor/catalog/items/next_steps_bar_catalog_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(nextStepsBarItem, () {
    test('has correct name and schema keys', () {
      expect(nextStepsBarItem.name, 'NextStepsBar');

      final schema = nextStepsBarItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['suggestions']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['suggestions']));
    });
  });
}
