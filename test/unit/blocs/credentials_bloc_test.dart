import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/authentication/authentication_bloc.dart' hide Init;
import 'package:dashboard/blocs/credentials/credentials_bloc.dart';
import 'package:dashboard/models/credentials.dart';
import 'package:dashboard/repositories/credentials_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCredentialsRepository extends Mock implements CredentialsRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}
class MockCredentials extends Mock implements Credentials {}

void main() {
  group("Credentials Bloc Tests", () {
    late CredentialsRepository credentialsRepository;
    late AuthenticationBloc authenticationBloc;
    late CredentialsBloc credentialsBloc;

    setUp(() {
      credentialsRepository = MockCredentialsRepository();
      authenticationBloc = MockAuthenticationBloc();
      when(() => authenticationBloc.isAuthenticated).thenReturn(false);
      whenListen(authenticationBloc, Stream.fromIterable([Unknown()]));
      credentialsBloc = CredentialsBloc(credentialsRepository: credentialsRepository, authenticationBloc: authenticationBloc);
    });

    tearDown(() {
      credentialsBloc.close();
    });

    test("CredentialsBloc initial state is CredentialsInitial", () {
      expect(credentialsBloc.state, isA<CredentialsInitial>());
    });

    blocTest<CredentialsBloc, CredentialsState>(
      "CredentialsBloc event Init fetches credentials",
      build: () {
        when(() => credentialsRepository.fetch()).thenAnswer((_) async => MockCredentials());
        return credentialsBloc;
      },
      act: (bloc) => bloc.add(Init()),
      verify: (_) {
        verify(() => credentialsRepository.fetch()).called(1);
      }
    );

    blocTest<CredentialsBloc, CredentialsState>(
      "CredentialsBloc event Init yields CredentialsLoading, CredentialsLoaded on Success",
      build: () {
        when(() => credentialsRepository.fetch()).thenAnswer((_) async => MockCredentials());
        return credentialsBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [isA<CredentialsLoading>(), isA<CredentialsLoaded>()]
    );

    blocTest<CredentialsBloc, CredentialsState>(
      "CredentialsBloc event Init yields CredentialsLoading, FailedToFetchCredentials on Fail",
      build: () {
        when(() => credentialsRepository.fetch()).thenThrow(ApiException(error: "error"));
        return credentialsBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [isA<CredentialsLoading>(), isA<FailedToFetchCredentials>()]
    );
  });
}