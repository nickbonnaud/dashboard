import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Paginate Data Holder tests", () {

    test("Paginate Data Holder can update it's attributes", () {
      final List<String> oldList = ["oldList"];
      PaginateDataHolder holder = PaginateDataHolder(data: oldList, next: "");
      expect(holder.data, oldList);
      final List<String> newList = ['newList'];
      holder = holder.update(data: newList);
      expect(holder.data != oldList, true);
      expect(holder.data, newList);
    });
  });
}