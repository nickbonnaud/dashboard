import 'package:dashboard/models/business/accounts.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  
  group("Accounts Tests", () {

    test('Accounts can deserialize json', () {
      final Map<String, dynamic> json = MockResponses.generateAccounts();
      var accounts = Accounts.fromJson(json: json);
      expect(accounts is Accounts, true);
    });

    test('Accounts can create an empty placeholder', () {
      var accounts = Accounts.empty();
      expect(accounts is Accounts, true);
    });

    test("Accounts can update it's attributes", () {
      final Map<String, dynamic> json = MockResponses.generateAccounts();
      var accounts = Accounts.fromJson(json: json);
      final BusinessAccount oldBusinessAccount = accounts.businessAccount;
      final BusinessAccount newBusinessAccount = BusinessAccount.fromJson(json: MockResponses.generateBusinessAccount());

      expect(accounts.businessAccount == oldBusinessAccount, true);
      expect(accounts.businessAccount == newBusinessAccount, false);

      accounts = accounts.update(businessAccount: newBusinessAccount);
      expect(accounts.businessAccount == oldBusinessAccount, false);
      expect(accounts.businessAccount == newBusinessAccount, true);
    });
  });
}