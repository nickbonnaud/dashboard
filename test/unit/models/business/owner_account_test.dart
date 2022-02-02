import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Owner Account Tests', () {

    test("An Owner Account can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateOwnerAccount();
      var ownerAccount = OwnerAccount.fromJson(json: json);
      expect(ownerAccount, isA<OwnerAccount>());
    });
  });
}