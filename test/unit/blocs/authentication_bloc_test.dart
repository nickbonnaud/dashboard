import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockBusiness extends Mock implements Business {}

void main() {
  group("Authentication Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      authenticationBloc = AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        businessBloc: BusinessBloc(
          businessRepository: const BusinessRepository()
        ));
    });

    tearDown(() {
      authenticationBloc.close();
    });
    
    test("Initial State of Authentication Bloc is Unknown", () {
      expect(authenticationBloc.state, isA<Unknown>());
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      "AuthenticationBloc Init checks if Logged In", 
      build: () {
        when(() => authenticationRepository.isSignedIn()).thenReturn(true);
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(Init()),
      verify: (_) {
        verify(() => authenticationRepository.isSignedIn()).called(1);
      }
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "AuthenticationBloc Init yields Authenticated if is signed in", 
      build: () {
        when(() => authenticationRepository.isSignedIn()).thenReturn(true);
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [isA<Authenticated>()]
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "AuthenticationBloc Init yields Unauthenticated if not signed in", 
      build: () {
        when(() => authenticationRepository.isSignedIn()).thenReturn(false);
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [isA<Unauthenticated>()]
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "AuthenticationBloc LoggedIn yields Authenticated", 
      build: () => authenticationBloc,
      act: (bloc) => bloc.add(LoggedIn(business: MockBusiness())),
      expect: () => [isA<Authenticated>()]
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "AuthenticationBloc LoggedOut calls logout on authentication repository", 
      build: () {
        when(() => authenticationRepository.logout()).thenAnswer((_) async => true);
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(LoggedOut()),
      verify: (_) {
        verify(() => authenticationRepository.logout()).called(1);
      }
    );
    
    blocTest<AuthenticationBloc, AuthenticationState>(
      "AuthenticationBloc LoggedOut yields Unauthenticated if success", 
      build: () {
        when(() => authenticationRepository.logout()).thenAnswer((_) async => true);
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(LoggedOut()),
      expect: () => [isA<Unauthenticated>()]
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "AuthenticationBloc LoggedOut maintains current state if fail",
      seed: () => Authenticated(),
      build: () {
        when(() => authenticationRepository.logout()).thenAnswer((_) async => false);
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(LoggedOut()),
      expect: () => [],
      verify: (_) {
        return authenticationBloc.state is Authenticated;
      }
    );
  });
}