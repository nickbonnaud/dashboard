import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/credentials.dart';
import 'package:dashboard/providers/credentials_provider.dart';
import 'package:dashboard/repositories/credentials_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCredentialsProvider extends Mock implements CredentialsProvider {}

void main() {
  group("Credentials Repository Tests", () {
    late CredentialsRepository _credentialsRepository;
    late CredentialsProvider _mockCredentialsProvider;
    late CredentialsRepository _credentialsRepositoryWithMock;

    setUp(() {
      _credentialsRepository = const CredentialsRepository();
      _mockCredentialsProvider = MockCredentialsProvider();
      _credentialsRepositoryWithMock = CredentialsRepository(credentialsProvider: _mockCredentialsProvider);
    });
    
    test("Credentials Repository can Fetch credentials", () async {
      var credentials = await _credentialsRepository.fetch();
      expect(credentials, isA<Credentials>());
    });

    test("Credentials Repository throws error on Fetch credentials fail", () async {
      when(() => _mockCredentialsProvider.fetch()).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));
      expect(
        _credentialsRepositoryWithMock.fetch(), 
        throwsA(isA<ApiException>())
      );
    });
  });
}