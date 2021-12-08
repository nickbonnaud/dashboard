import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/screens/message_list_screen/bloc/message_list_screen_bloc.dart';
import 'package:dashboard/screens/message_screen/bloc/message_history_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMessageListScreenBloc extends Mock implements MessageListScreenBloc {}
class MockMessage extends Mock implements Message {}
class MockMessageListScreenEvent extends Mock implements MessageListScreenEvent {}

main() {
  group("Message History Bloc Tests", () {
    late MessageListScreenBloc messageListScreenBloc;
    late Message message;
    late MessageHistoryBloc messageHistoryBloc;

    late Reply _newReply;

    setUp(() {
      registerFallbackValue(MockMessageListScreenEvent());
      messageListScreenBloc = MockMessageListScreenBloc();
      when(() => messageListScreenBloc.add(any(that: isA<MessageListScreenEvent>()))).thenReturn(null);
      message = MockMessage();
      messageHistoryBloc = MessageHistoryBloc(messageListScreenBloc: messageListScreenBloc, message: message);
    });

    tearDown(() {
      messageHistoryBloc.close();
    });

    Reply _generateReply() {
      return Reply(
        identifier: faker.guid.guid(), 
        body: faker.lorem.sentences(2).fold("", (previousValue, currentValue) => "$previousValue $currentValue"), 
        fromBusiness: false, 
        read: false, 
        createdAt: DateTime.now(), 
        updatedAt: DateTime.now()
      );
    }
    
    Message _generateMessage() {
      return Message(
        identifier: faker.guid.guid(),
        title: faker.lorem.sentence(),
        body: faker.lorem.sentences(4).fold("", (previousValue, currentValue) => "$previousValue $currentValue"),
        fromBusiness: false,
        read: false,
        unreadReply: true,
        latestReply: DateTime.now(), 
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        replies: List.generate(1, (index) => _generateReply())
      );
    }
    
    test("Initial state of MessageHistoryBloc is MessageHistoryState.initial()", () {
      expect(messageHistoryBloc.state, MessageHistoryState.initial(message: message));
    });

    blocTest<MessageHistoryBloc, MessageHistoryState>(
      "MarkAsRead event changes state: [message]",
      build: () => messageHistoryBloc,
      seed: () {
        message = _generateMessage();
        return MessageHistoryState.initial(message: message);
      },
      act: (bloc) {
        bloc.add(MarkAsRead());
      },
      expect: () => [MessageHistoryState(message: message.update(
        replies: [message.replies.first.update(read: true)],
        read: true
      ))]
    );

    blocTest<MessageHistoryBloc, MessageHistoryState>(
      "MarkAsRead event calls MessageListScreenBloc.add",
      build: () => messageHistoryBloc,
      seed: () {
        message = _generateMessage();
        return MessageHistoryState.initial(message: message);
      },
      act: (bloc) {
        bloc.add(MarkAsRead());
      },
      verify: (_) {
        verify(() => messageListScreenBloc.add(any(that: isA<MessageUpdated>())));
      }
    );

    blocTest<MessageHistoryBloc, MessageHistoryState>(
      "ReplyAdded event changes state: [message]",
      build: () => messageHistoryBloc,
      seed: () {
        message = _generateMessage();
        return MessageHistoryState.initial(message: message);
      },
      act: (bloc) {
        _newReply = _generateReply();
        bloc.add(ReplyAdded(reply: _newReply));
      },
      expect: () => [MessageHistoryState(message: message.update(
        replies: message.replies..insert(0, _newReply),
        latestReply: messageHistoryBloc.state.message.latestReply
      ))]
    );

    blocTest<MessageHistoryBloc, MessageHistoryState>(
      "ReplyAdded event calls MessageListScreenBloc.add()",
      build: () => messageHistoryBloc,
      seed: () {
        message = _generateMessage();
        return MessageHistoryState.initial(message: message);
      },
      act: (bloc) {
        _newReply = _generateReply();
        bloc.add(ReplyAdded(reply: _newReply));
      },
      verify: (_) {
        verify(() => messageListScreenBloc.add(any(that: isA<MessageUpdated>())));
      }
    );
  });
}