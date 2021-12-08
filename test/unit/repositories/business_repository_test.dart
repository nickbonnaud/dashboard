import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/providers/business_provider.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBusinessProvider extends Mock implements BusinessProvider {}

void main() {
  
  group("Business Repository Tests", () {
    final TokenRepository _tokenRepository = TokenRepository();
    late BusinessRepository _businessRepository;
    late BusinessProvider _mockBusinessProvider;
    late BusinessRepository _businessRepositoryWithMock;

    setUp(() {
      _businessRepository = BusinessRepository(businessProvider: BusinessProvider(), tokenRepository: _tokenRepository);
      _mockBusinessProvider = MockBusinessProvider();
      _businessRepositoryWithMock = BusinessRepository(businessProvider: _mockBusinessProvider, tokenRepository: _tokenRepository);
      registerFallbackValue(Map());
    });
    
    test("Business Repository can Fetch a business", () async {
      var business = await _businessRepository.fetch();
      expect(business is Business, true);
    });

    test("Business Repository throws error on Fetch business fail", () async {
      when(() => _mockBusinessProvider.fetch()).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      expect(
        _businessRepositoryWithMock.fetch(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Fetching a business Stores CSRF token", () async {
      _tokenRepository.deleteToken();
      var token = _tokenRepository.fetchToken();
      expect(token == null, true);
      await _businessRepository.fetch();
      token = _tokenRepository.fetchToken();
      expect(token == null, false);
    });

    test("Business Repository can Update email", () async {
      final String email = faker.internet.email();
      final String identifier = faker.guid.guid();
      var newEmail = await _businessRepository.updateEmail(email: email, identifier: identifier);
      expect(newEmail, email);
    });

    test("Business Repository throws error on Update email fail", () async {
      final String email = faker.internet.email();
      final String identifier = faker.guid.guid();
      when(() => _mockBusinessProvider.update(body: any(named: "body"), identifier: identifier)).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _businessRepositoryWithMock.updateEmail(email: email, identifier: identifier),
        throwsA(isA<ApiException>())
      );
    });

    test("The Business Repository can update Password", () async {
      final String newPassword = faker.internet.password();
      final String identifier = faker.guid.guid();
      var passwordReset = await _businessRepository.updatePassword(password: newPassword, passwordConfirmation: newPassword, identifier: identifier);
      expect(passwordReset is bool, true);
    });

    test("The Business Repository throws error on Update Password fail", () async {
      final String newPassword = faker.internet.password();
      final String identifier = faker.guid.guid();
      when(() => _mockBusinessProvider.update(body: any(named: 'body'), identifier: identifier)).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _businessRepositoryWithMock.updatePassword(password: newPassword, passwordConfirmation: newPassword, identifier: identifier),
        throwsA(isA<ApiException>())
      );
    });
  });
}