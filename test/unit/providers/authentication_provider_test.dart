import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/authentication_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Authentication Provider Tests", () {
    late AuthenticationProvider authenticationProvider;

    setUp(() {
      authenticationProvider = AuthenticationProvider();
    });

    test("Registering a business returns ApiResponse", () async {
      var response = await authenticationProvider.register(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Logging in a business returns ApiResponse", () async {
      var response = await authenticationProvider.login(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Logging out a business returns ApiResponse", () async {
      var response = await authenticationProvider.logout();
      expect(response, isA<ApiResponse>());
    });

    test("Verifying password of a business returns ApiResponse", () async {
      var response = await authenticationProvider.verifyPassword(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Request password reset of a business returns ApiResponse", () async {
      var response = await authenticationProvider.requestPasswordReset(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("reset password returns ApiResponse", () async {
      var response = await authenticationProvider.resetPassword(body: {});
      expect(response, isA<ApiResponse>());
    });
  });
}