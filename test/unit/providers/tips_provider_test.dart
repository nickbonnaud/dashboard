import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/tips_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Tips Provider Tests", () {
    late TipsProvider tipsProvider;

    setUp(() {
      tipsProvider = const TipsProvider();
    });

    test("FetchPaginated tips returns PaginatedApiResponse", () async {
      var response = await tipsProvider.fetchPaginated(query: "employees=all");
      expect(response, isA<PaginatedApiResponse>());
    });
  });
}