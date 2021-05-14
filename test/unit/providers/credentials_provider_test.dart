import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/credentials_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Credentials Provider Tests", () {
    late CredentialsProvider credentialsProvider;

    setUp(() {
      credentialsProvider = CredentialsProvider();
    });

    test("Fetching Credentials returns ApiResponse", () async {
      var response = await credentialsProvider.fetch();
      expect(response, isA<ApiResponse>());
    });
  });
}