import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/unassigned_transaction_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Unassigned Transaction Provider Tests", () {
    late UnassignedTransactionProvider unassignedTransactionProvider;

    setUp(() {
      unassignedTransactionProvider = UnassignedTransactionProvider();
    });

    test("Fetching unassigned transactions returns PaginatedApiResponse", () async {
      var response = await unassignedTransactionProvider.fetch();
      expect(response, isA<PaginatedApiResponse>());
    });
  });
}