import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/authentication/authentication_bloc.dart' hide Init;
import 'package:dashboard/blocs/messages/messages_bloc.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMessageRepository extends Mock implements MessageRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

void main() {
  group("Messages Bloc Tests", () {
    late MessageRepository messageRepository;
    late AuthenticationBloc authenticationBloc;
    late MessagesBloc messagesBloc;

    setUp(() {
      messageRepository = MockMessageRepository();
      authenticationBloc = MockAuthenticationBloc();
      when(() => authenticationBloc.isAuthenticated).thenReturn(false);
      whenListen(authenticationBloc, Stream.fromIterable([Unknown()]));
      messagesBloc = MessagesBloc(messageRepository: messageRepository, authenticationBloc: authenticationBloc);
    });

    tearDown(() {
      messagesBloc.close();
    });

    test("MessagesBloc initial state is MessagesState.initial()", () {
      expect(messagesBloc.state == MessagesState.initial(), true);
    });

    blocTest<MessagesBloc, MessagesState>(
      "MessagesBloc event Init calls checkHasUnreadMessages", 
      build: () {
        when(() => messageRepository.checkUnreadMessages()).thenAnswer((_) async => true);
        return messagesBloc;
      },
      act: (bloc) => bloc.add(Init()),
      verify: (_) {
        verify(() => messageRepository.checkUnreadMessages()).called(1);
      }
    );

    blocTest<MessagesBloc, MessagesState>(
      "MessagesBloc event Init yields [loading=true], [loading=false, hasUnreadMessages=true] on success", 
      build: () {
        when(() => messageRepository.checkUnreadMessages()).thenAnswer((_) async => true);
        return messagesBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [
        MessagesState(loading: true, hasUnreadMessages: false, errorMessage: ""),
        MessagesState(loading: false, hasUnreadMessages: true, errorMessage: ""),
      ]
    );

    blocTest<MessagesBloc, MessagesState>(
      "MessagesBloc event Init yields [loading=true], [loading=false, errorMessage=message] on error", 
      build: () {
        when(() => messageRepository.checkUnreadMessages()).thenThrow(ApiException(error: "error"));
        return messagesBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [
        MessagesState(loading: true, hasUnreadMessages: false, errorMessage: ""),
        MessagesState(loading: false, hasUnreadMessages: false, errorMessage: "error"),
      ]
    );
  });
}