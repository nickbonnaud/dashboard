import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/transaction_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Transaction Provider Tests", () {
    late TransactionProvider transactionProvider;

    setUp(() {
      transactionProvider = TransactionProvider();
    });

    test("Fetching transaction sums returns ApiResponse", () async {
      var response = await transactionProvider.fetch(query: "?sum=net_sales");
      expect(response, isA<ApiResponse>());
    });

    test("Fetching transactions returns PaginatedApiResponse", () async {
      var response = await transactionProvider.fetchPaginated();
      expect(response, isA<PaginatedApiResponse>());
    });
  });
}