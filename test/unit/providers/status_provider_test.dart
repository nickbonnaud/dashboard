
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/status_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Status Provider Tests", () {
    late StatusProvider statusProvider;

    setUp(() {
      statusProvider = StatusProvider();
    });

    test("FetchTransactionStatuses returns PaginatedApiResponse", () async {
      var response = await statusProvider.fetchTransactionStatuses();
      expect(response, isA<PaginatedApiResponse>());
    });
  });
}