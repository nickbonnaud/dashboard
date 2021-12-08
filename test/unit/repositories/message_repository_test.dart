import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/message_provider.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMessageProvider extends Mock implements MessageProvider {}

void main() {
  group("Message Repository Tests", () {
    late MessageRepository _messageRepository;
    late MessageProvider _mockMessageProvider;
    late MessageRepository _messageRepositoryWithMock;

    setUp(() {
      _messageRepository = MessageRepository(messageProvider: MessageProvider());
      _mockMessageProvider = MockMessageProvider();
      _messageRepositoryWithMock = MessageRepository(messageProvider: _mockMessageProvider);
      registerFallbackValue(Map());
    });
    
    test("Message Repository can Check Unread Messages", () async {
      var hasUnread = await _messageRepository.checkUnreadMessages();
      expect(hasUnread is bool, true);
    });

    test("Message Repository throws error on Check Unread Messages fail", () async {
      when(() => _mockMessageProvider.fetch()).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      expect(
        _messageRepositoryWithMock.checkUnreadMessages(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Message Repository can Fetch All messages", () async {
      var messagePaginateData = await _messageRepository.fetchAll();
      expect(messagePaginateData is PaginateDataHolder, true);
      expect(messagePaginateData.data is List<Message>, true);
      expect(messagePaginateData.data.isNotEmpty, true);
    });

    test("Message Repository throws error on Fetch All messages fail", () async {
      when(() => _mockMessageProvider.fetchPaginated()).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      expect(
        _messageRepositoryWithMock.fetchAll(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Message Repository can Paginate", () async {
      final String url = "http://novapay.ai/api/business/message?page=2";
      var messagePaginateData = await _messageRepository.paginate(url: url);
      expect(messagePaginateData is PaginateDataHolder, true);
      expect(messagePaginateData.data is List<Message>, true);
    });

    test("Message Repository throws error on Paginate fail", () async {
      final String url = "http://novapay.ai/api/business/message?page=2";
      when(() => _mockMessageProvider.fetchPaginated(paginateUrl: any(named: 'paginateUrl'))).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      expect(
        _messageRepositoryWithMock.paginate(url: url), 
        throwsA(isA<ApiException>())
      );
    });

    test("Message Repository can Add Message", () async {
      final String title = faker.lorem.sentence();
      final String body = faker.lorem.sentence();
      var message = await _messageRepository.addMessage(title: title, messageBody: body);
      expect(message is Message, true);
    });

    test("Message Repository throws error on Add Message", () async {
      final String title = faker.lorem.sentence();
      final String body = faker.lorem.sentence();
      when(() => _mockMessageProvider.storeMessage(body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _messageRepositoryWithMock.addMessage(title: title, messageBody: body), 
        throwsA(isA<ApiException>())
      );
    });

    test("Message Repository can Add Reply", () async {
      final String identifier = faker.guid.guid();
      final String body = faker.lorem.sentence();
      var reply = await _messageRepository.addReply(messageIdentifier: identifier, replyBody: body);
      expect(reply is Reply, true);
    });

    test("Message Repository throws error on Add Reply fail", () async {
      final String identifier = faker.guid.guid();
      final String body = faker.lorem.sentence();
      when(() => _mockMessageProvider.storeReply(body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _messageRepositoryWithMock.addReply(messageIdentifier: identifier, replyBody: body), 
        throwsA(isA<ApiException>())
      );
    });

    test("Message Repository can Update Message", () async {
      final String identifier = faker.guid.guid();
      var messageUpdated = await _messageRepository.updateMessage(messageIdentifier: identifier);
      expect(messageUpdated is bool, true);
    });

    test("Message Repository throws error on Update Message fail", () async {
      final String identifier = faker.guid.guid();
      when(() => _mockMessageProvider.updateMessage(messageIdentifier: identifier, body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _messageRepositoryWithMock.updateMessage(messageIdentifier: identifier), 
        throwsA(isA<ApiException>())
      );
    });
  });
}