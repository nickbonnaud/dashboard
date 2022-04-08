import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/message_screen/bloc/message_history_bloc.dart';
import 'package:dashboard/screens/message_screen/widgets/widgets/message_input/bloc/message_input_bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMessageRepository extends Mock implements MessageRepository {}
class MockMessageHistoryBloc extends Mock implements MessageHistoryBloc {}
class MockReply extends Mock implements Reply {}
class MockMessageHistoryEvent extends Mock implements MessageHistoryEvent {}

void main() {
  group("Message Input Bloc Tests", () {
    late MessageRepository messageRepository;
    late MessageHistoryBloc messageHistoryBloc;
    late MessageInputBloc messageInputBloc;

    late MessageInputState _baseState;

    setUp(() {
      messageRepository = MockMessageRepository();
      messageHistoryBloc = MockMessageHistoryBloc();
      messageInputBloc = MessageInputBloc(messageRepository: messageRepository, messageHistoryBloc: messageHistoryBloc);
      _baseState = messageInputBloc.state;
      registerFallbackValue(MockMessageHistoryEvent());
    });

    tearDown(() {
      messageInputBloc.close();
    });

    test("Initial state of MessageInputBloc is MessageInputState.initial()", () {
      expect(messageInputBloc.state, MessageInputState.initial());
    });

    blocTest<MessageInputBloc, MessageInputState>(
      "MessageChanged event changes state: [isInputValid: false]", 
      build: () => messageInputBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const MessageChanged(message: "  ")),
      expect: () => [_baseState.update(isInputValid: false)]
    );

    blocTest<MessageInputBloc, MessageInputState>(
      "Submitted event changes state: [isSubmitting: true, errorMessage: ""], [isSubmitting: false]", 
      build: () => messageInputBloc,
      act: (bloc) {
        String reply = faker.lorem.sentence();
        String identifier = faker.guid.guid();
        when(() => messageRepository.addReply(messageIdentifier: identifier, replyBody: reply)).thenAnswer((_) async => MockReply());
        when(() => messageHistoryBloc.add(any(that: isA<MessageHistoryEvent>()))).thenReturn(null);
        bloc.add(Submitted(message: reply, messageIdentifier: identifier));
      },
      expect: () => [_baseState.update(isSubmitting: true, errorMessage: ""), _baseState.update(isSubmitting: false)]
    );

    blocTest<MessageInputBloc, MessageInputState>(
      "Submitted event calls _messageRepository.addReply()", 
      build: () => messageInputBloc,
      act: (bloc) {
        String reply = faker.lorem.sentence();
        String identifier = faker.guid.guid();
        when(() => messageRepository.addReply(messageIdentifier: identifier, replyBody: reply)).thenAnswer((_) async => MockReply());
        when(() => messageHistoryBloc.add(any(that: isA<MessageHistoryEvent>()))).thenReturn(null);
        bloc.add(Submitted(message: reply, messageIdentifier: identifier));
      },
      verify: (_) {
        verify(() => messageRepository.addReply(messageIdentifier: any(named: "messageIdentifier"), replyBody: any(named: "replyBody"))).called(1);
      }
    );

    blocTest<MessageInputBloc, MessageInputState>(
      "Submitted event calls _messageHistoryBloc.add()", 
      build: () => messageInputBloc,
      act: (bloc) {
        String reply = faker.lorem.sentence();
        String identifier = faker.guid.guid();
        when(() => messageRepository.addReply(messageIdentifier: identifier, replyBody: reply)).thenAnswer((_) async => MockReply());
        when(() => messageHistoryBloc.add(any(that: isA<MessageHistoryEvent>()))).thenReturn(null);
        bloc.add(Submitted(message: reply, messageIdentifier: identifier));
      },
      verify: (_) {
        verify(() => messageHistoryBloc.add(any(that: isA<MessageHistoryEvent>()))).called(1);
      }
    );

    blocTest<MessageInputBloc, MessageInputState>(
      "Submitted event on error changes state: [isSubmitting: true, errorMessage: ""], [isSubmitting: false, errorMessage: 'error']", 
      build: () => messageInputBloc,
      act: (bloc) {
        String reply = faker.lorem.sentence();
        String identifier = faker.guid.guid();
        when(() => messageRepository.addReply(messageIdentifier: identifier, replyBody: reply)).thenThrow(const ApiException(error: "error"));
        bloc.add(Submitted(message: reply, messageIdentifier: identifier));
      },
      expect: () => [_baseState.update(isSubmitting: true, errorMessage: ""), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );
  });
}