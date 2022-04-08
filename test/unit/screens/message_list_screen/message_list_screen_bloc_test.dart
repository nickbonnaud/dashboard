import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/message_list_screen/bloc/message_list_screen_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMessageRepository extends Mock implements MessageRepository {}
class MockMessage extends Mock implements Message {}

void main() {
  group("Message List Screen Bloc Test", () {
    late MessageRepository messageRepository;
    late MessageListScreenBloc messageListScreenBloc;

    late MessageListScreenState baseState;
    late List<Message> _messagesList;

    Message _addMessageAttributes({required Message message}) {
      when(() => message.hasUnread).thenReturn(faker.randomGenerator.boolean());
      when(() => message.identifier).thenReturn(faker.guid.guid());
      when(() => message.latestReply).thenReturn(faker.date.dateTime(minYear: 2019, maxYear: 2021));
      return message;
    }
    
    List<Message> _generateMessages({int numMessages = 10}) {
      return List.generate(numMessages, (_) {
        Message message = MockMessage();
        _addMessageAttributes(message: message);
        return message;
      });
    }

    List<Message> _sortMessages() {
      final List<Message> unreadMessages = _messagesList.where((message) => message.hasUnread).toList();
      final List<Message> readMessages = _messagesList.where((message) => !message.hasUnread).toList();
      return unreadMessages..addAll(readMessages);
    }

    setUp(() {
      messageRepository = MockMessageRepository();
      messageListScreenBloc = MessageListScreenBloc(messageRepository: messageRepository);
      baseState = messageListScreenBloc.state;
    });

    tearDown(() {
      messageListScreenBloc.close();
    });

    test("Initial state of MessageListScreenBloc is MessageListScreenState.initial()", () {
      expect(messageListScreenBloc.state, MessageListScreenState.initial());
    });

    blocTest<MessageListScreenBloc, MessageListScreenState>(
      "Init event changes state: [loading: true, errorMessage: ""], [loading: false, messages: List<MockMessages>, nextUrl: next, hasReachedEnd: false]",
      build: () => messageListScreenBloc,
      act: (bloc) {
        _messagesList = _generateMessages();
        when(() => messageRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _messagesList, next: "next"));
        bloc.add(Init());
      },
      expect: () {
        _messagesList = _sortMessages();
        return [baseState.update(loading: true, errorMessage: ""), baseState.update(loading: false, messages: _messagesList, nextUrl: "next", hasReachedEnd: false)];
      }
    );

    blocTest<MessageListScreenBloc, MessageListScreenState>(
      "Init event changes calls _messageRepository.fetchAll",
      build: () => messageListScreenBloc,
      act: (bloc) {
        _messagesList = _generateMessages();
        when(() => messageRepository.fetchAll()).thenAnswer((_) async => PaginateDataHolder(data: _messagesList, next: "next"));
        bloc.add(Init());
      },
      verify: (_) {
        verify(() => messageRepository.fetchAll()).called(1);
      }
    );

    blocTest<MessageListScreenBloc, MessageListScreenState>(
      "Init event on error changes state: [loading: true, errorMessage: ""], [loading: false, errorMessage: error]",
      build: () => messageListScreenBloc,
      act: (bloc) {
        when(() => messageRepository.fetchAll()).thenThrow(const ApiException(error: "error"));
        bloc.add(Init());
      },
      expect: () {
        return [baseState.update(loading: true, errorMessage: ""), baseState.update(loading: false, errorMessage: "error")];
      }
    );

    blocTest<MessageListScreenBloc, MessageListScreenState>(
      "FetchMore event changes state: [paginating: true] [loading: false, messages: List<MockMessages>, nextUrl: null, hasReachedEnd: true, paginating: false]",
      build: () => messageListScreenBloc,
      seed: () {
        _messagesList = _generateMessages();
        _messagesList = _sortMessages();
        baseState = baseState.update(messages: _messagesList, nextUrl: "nextUrl");
        return baseState;
      },
      act: (bloc) {
        List<Message> paginatedMessages = _generateMessages();
        _messagesList = _messagesList + paginatedMessages;
        when(() => messageRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: paginatedMessages, next: null));
        bloc.add(FetchMore());
      },
      expect: () {
        _messagesList = _sortMessages();
        var firstState = baseState.update(paginating: true);
        var secondState = firstState.update(messages: _messagesList, nextUrl: null, hasReachedEnd: true, paginating: false);
        return [firstState, secondState];
      }
    );

    blocTest<MessageListScreenBloc, MessageListScreenState>(
      "FetchMore event calls messageRepository.paginate()",
      build: () => messageListScreenBloc,
      seed: () {
        _messagesList = _generateMessages();
        _messagesList = _sortMessages();
        return baseState.update(messages: _messagesList, nextUrl: "nextUrl");
      },
      act: (bloc) {
        List<Message> paginatedMessages = _generateMessages();
        _messagesList = _messagesList + paginatedMessages;
        when(() => messageRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: paginatedMessages, next: null));
        bloc.add(FetchMore());
      },
      verify: (_) {
        verify(() => messageRepository.paginate(url: any(named: "url"))).called(1);
      }
    );

    blocTest<MessageListScreenBloc, MessageListScreenState>(
      "FetchMore event on error changes state: [paginating: true] [loading: false, messages: List<MockMessages>, nextUrl: null, hasReachedEnd: true, paginating: false]",
      build: () => messageListScreenBloc,
      seed: () {
        _messagesList = _generateMessages();
        _messagesList = _sortMessages();
        baseState = baseState.update(messages: _messagesList, nextUrl: "nextUrl");
        return baseState;
      },
      act: (bloc) {
        when(() => messageRepository.paginate(url: any(named: "url")))
          .thenThrow(const ApiException(error: "error"));
        bloc.add(FetchMore());
      },
      expect: () {
        var firstState = baseState.update(paginating: true);
        var secondState = firstState.update(loading: false, errorMessage: "error", paginating: false);
        return [firstState, secondState];
      }
    );

    blocTest<MessageListScreenBloc, MessageListScreenState>(
      "MessageUpdated event updates correct message",
      build: () => messageListScreenBloc,
      seed: () {
        _messagesList = _generateMessages();
        Message messageToUpdate = Message(
          identifier: "identifier", 
          title: "title", 
          body: "body", 
          fromBusiness: false, 
          read: false, 
          unreadReply: true, 
          latestReply: DateTime.now(), 
          createdAt: DateTime.now(), 
          updatedAt: DateTime.now(), 
          replies: const []
        );
        _messagesList.add(messageToUpdate);
        _messagesList = _sortMessages();
        baseState = baseState.update(messages: _messagesList, nextUrl: "nextUrl");
        return baseState;
      },
      act: (bloc) {
        Message messageToUpdate = _messagesList.firstWhere((message) => message.identifier == "identifier");
        messageToUpdate = messageToUpdate.update(read: true, unreadReply: false);
        when(() => messageRepository.updateMessage(messageIdentifier: any(named: "messageIdentifier")))
          .thenAnswer((_) async => true);
        bloc.add(MessageUpdated(message: messageToUpdate, messageHistoryRead: false));
      },
      verify: (_) {
        Message updatedMessage = messageListScreenBloc.state.messages.firstWhere((message) => message.identifier == "identifier");
        expect(updatedMessage.read, true);
        expect(updatedMessage.hasUnread, false);
      }
    );

    blocTest<MessageListScreenBloc, MessageListScreenState>(
      "MessageUpdated event does not call messageRepository.updateMessage() if messageHistoryRead = false",
      build: () => messageListScreenBloc,
      seed: () {
        _messagesList = _generateMessages();
        Message messageToUpdate = Message(
          identifier: "identifier", 
          title: "title", 
          body: "body", 
          fromBusiness: false, 
          read: false, 
          unreadReply: true, 
          latestReply: DateTime.now(), 
          createdAt: DateTime.now(), 
          updatedAt: DateTime.now(), 
          replies: const []
        );
        _messagesList.add(messageToUpdate);
        _messagesList = _sortMessages();
        baseState = baseState.update(messages: _messagesList, nextUrl: "nextUrl");
        return baseState;
      },
      act: (bloc) {
        Message messageToUpdate = _messagesList.firstWhere((message) => message.identifier == "identifier");
        messageToUpdate = messageToUpdate.update(read: true, unreadReply: false);
        when(() => messageRepository.updateMessage(messageIdentifier: any(named: "messageIdentifier")))
          .thenAnswer((_) async => true);
        bloc.add(MessageUpdated(message: messageToUpdate, messageHistoryRead: false));
      },
      verify: (_) {
        verifyNever(() => messageRepository.updateMessage(messageIdentifier: any(named: "messageIdentifier")));
      }
    );

    blocTest<MessageListScreenBloc, MessageListScreenState>(
      "MessageUpdated event calls messageRepository.updateMessage() if messageHistoryRead = true",
      build: () => messageListScreenBloc,
      seed: () {
        _messagesList = _generateMessages();
        Message messageToUpdate = Message(
          identifier: "identifier", 
          title: "title", 
          body: "body", 
          fromBusiness: false, 
          read: false, 
          unreadReply: true, 
          latestReply: DateTime.now(), 
          createdAt: DateTime.now(), 
          updatedAt: DateTime.now(), 
          replies: const []
        );
        _messagesList.add(messageToUpdate);
        _messagesList = _sortMessages();
        baseState = baseState.update(messages: _messagesList, nextUrl: "nextUrl");
        return baseState;
      },
      act: (bloc) {
        Message messageToUpdate = _messagesList.firstWhere((message) => message.identifier == "identifier");
        messageToUpdate = messageToUpdate.update(read: true, unreadReply: false);
        when(() => messageRepository.updateMessage(messageIdentifier: any(named: "messageIdentifier")))
          .thenAnswer((_) async => true);
        bloc.add(MessageUpdated(message: messageToUpdate, messageHistoryRead: true));
      },
      verify: (_) {
        verify(() => messageRepository.updateMessage(messageIdentifier: any(named: "messageIdentifier"))).called(1);
      }
    );
  });
}