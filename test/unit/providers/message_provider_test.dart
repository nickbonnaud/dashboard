
import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/message_provider.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group("Message Provider Tests", () {
    late MessageProvider messageProvider;

    setUp(() {
      messageProvider = MessageProvider();
    });

    test("Checking for unread returns ApiResponse", () async {
      var response = await messageProvider.fetch();
      expect(response, isA<ApiResponse>());
    });

    test("Fetching Messages returns PaginatedApiResponse", () async {
      var response = await messageProvider.fetchPaginated();
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Storing Message returns ApiResponse", () async {
      var response = await messageProvider.storeMessage(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Storing Reply returns ApiResponse", () async {
      var response = await messageProvider.storeReply(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Updating Reply returns ApiResponse", () async {
      var response = await messageProvider.updateMessage(body: {}, messageIdentifier: "messageIdentifier");
      expect(response, isA<ApiResponse>());
    });
  });
}