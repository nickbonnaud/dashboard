import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/customer_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Customer Provider Tests', () {
    late CustomerProvider customerProvider;

    setUp(() {
      customerProvider = CustomerProvider();
    });

    test("Fetching customers returns PaginatedApiResponse no url", () async {
      var response = await customerProvider.fetchPaginated();
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Fetching customers returns PaginatedApiResponse", () async {
      var response = await customerProvider.fetchPaginated();
      expect(response, isA<PaginatedApiResponse>());
    });
  });
}