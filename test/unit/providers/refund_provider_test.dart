import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/refund_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Refund Provider Tests", () {
    late RefundProvider refundProvider;

    setUp(() {
      refundProvider = RefundProvider();
    });

    test("Fetching sum refunds return ApiResponse", () async {
      var response = await refundProvider.fetch(query: "?sum=total");
      expect(response, isA<ApiResponse>());
    });

    test("Fetching refunds return PaginatedApiResponse", () async {
      var response = await refundProvider.fetchPaginated();
      expect(response, isA<PaginatedApiResponse>());
    });
  });
}