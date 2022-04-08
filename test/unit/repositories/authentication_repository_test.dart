import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/providers/authentication_provider.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationProvider extends Mock implements AuthenticationProvider {}

void main() {
  group("Authentication Respository Tests", () {
    late AuthenticationRepository _authRepository;
    late AuthenticationRepository _authRepositoryWithMock;
    late TokenRepository _tokenRepository;
    late AuthenticationProvider _mockAuthenticationProvider;

    setUp(() {
      _mockAuthenticationProvider = MockAuthenticationProvider();
      _authRepository = AuthenticationRepository(tokenRepository: TokenRepository(), authenticationProvider: AuthenticationProvider());
      _authRepositoryWithMock = AuthenticationRepository(tokenRepository: TokenRepository(), authenticationProvider: _mockAuthenticationProvider);
      _tokenRepository = TokenRepository();
    });
    
    test("Registering a Business return Business Model on Success", () async {
      final String email = faker.internet.email();
      final String password = faker.internet.password();
      var business = await _authRepository.register(email: email, password: password, passwordConfirmation: password);
      expect(business, isA<Business>());
    });

    test("Registering a Business throws error on fails", () async {
      final String email = faker.internet.email();
      final String password = faker.internet.password();

      final Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'password_confirmation': password
      };

      when (() => _mockAuthenticationProvider.register(body: body)).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));
      expect(_authRepositoryWithMock.register(email: email, password: password, passwordConfirmation: password), throwsA(isA<ApiException>()));
    });

    test("Registering a business saves CSRF token to token repository", () async {
      _tokenRepository.deleteToken();
      final String email = faker.internet.email();
      final String password = faker.internet.password();
      var token = _tokenRepository.fetchToken();
      expect(token == null, true);
      await _authRepository.register(email: email, password: password, passwordConfirmation: password);
      token = _tokenRepository.fetchToken();
      expect(token == null, false);
    });

    test("Logging in a Business returns Business Model on success", () async {
      final String email = faker.internet.email();
      final String password = faker.internet.password();
      var business = await _authRepository.login(email: email, password: password);
      expect(business, isA<Business>());
    });

    test("Logging in a Business throw error on fail", () async {
      final String email = faker.internet.email();
      final String password = faker.internet.password();

      final Map<String, dynamic> body = {
        "email": email,
        "password": password
      };

      when (() => _mockAuthenticationProvider.login(body: body)).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));
      expect(_authRepositoryWithMock.login(email: email, password: password), throwsA(isA<ApiException>()));
    });

    test("Logging in a business saves CSRF token to token repository", () async {
      _tokenRepository.deleteToken();
      final String email = faker.internet.email();
      final String password = faker.internet.password();
      var token = _tokenRepository.fetchToken();
      expect(token == null, true);
      await _authRepository.login(email: email, password: password);
      token = _tokenRepository.fetchToken();
      expect(token == null, false);
    });

    test("Logging Out a business is returned a bool on Success", () async {
      var loggedOut = await _authRepository.logout();
      expect(loggedOut, true);
    });

    test("Logging out a Business throws error on failure", () async {
      when (() => _mockAuthenticationProvider.logout()).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));
      expect(_authRepositoryWithMock.logout(), throwsA(isA<ApiException>()));
    });

    test("Logging Out a business deletes token from repository", () async {
      await _authRepository.login(email: faker.internet.email(), password: faker.internet.password());
      var token = _tokenRepository.fetchToken();
      expect(token != null, true);
      await _authRepository.logout();
      token = _tokenRepository.fetchToken();
      expect(token != null, false);
    });

    test("A Business can verify it's password successfully", () async {
      final String password = faker.internet.password();
      var passwordVerified = await _authRepository.verifyPassword(password: password);
      expect(passwordVerified, true);
    });

    test("Verifying Password throws error on failure", () async {
      final String password = faker.internet.password();
      final Map<String, dynamic> body = {
        'password': password
      };
      when (() => _mockAuthenticationProvider.verifyPassword(body: body)).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));
      expect(_authRepositoryWithMock.verifyPassword(password: password), throwsA(isA<ApiException>()));
    });

    test("A Business can request password reset", () async {
      final String email = faker.internet.email();
      var requestSent = await _authRepository.requestPasswordReset(email: email);
      expect(requestSent, true);
    });

    test("Requesting reset throws error on failure", () async {
      final String email = faker.internet.email();
      final Map<String, dynamic> body = {
        'email': email
      };
      when(() => _mockAuthenticationProvider.requestPasswordReset(body: body)).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));
      expect(_authRepositoryWithMock.requestPasswordReset(email: email), throwsA(isA<ApiException>()));
    });

    test("A Business can reset it's password", () async {
      final String password = faker.internet.password();
      final String token = faker.guid.guid();
      var passwordReset = await _authRepository.resetPassword(password: password, passwordConfirmation: password, token: token);
      expect(passwordReset, true);
    });

    test("Reseting Password throws error on fail", () async {
      final String password = faker.internet.password();
      final String token = faker.guid.guid();

      final Map<String, dynamic> body = {
        'password': password,
        'password_confirmation': password,
        'token': token
      };

      when(() => _mockAuthenticationProvider.resetPassword(body: body)).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));
      expect(_authRepositoryWithMock.resetPassword(password: password, passwordConfirmation: password, token: token), throwsA(isA<ApiException>()));
    });

    test("A Business can check if it is signed in", () {
      final isSignedIn = _authRepository.isSignedIn();
      expect(isSignedIn, isA<bool>());
    });
  });
}