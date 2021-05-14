import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockBusinessBloc extends Mock implements BusinessBloc {}

void main() {
  
  group("Bank Account Tests", () {

    test("A Bank Account can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateBankAccount();
      var bankAccount = BankAccount.fromJson(json: json);
      expect(bankAccount is BankAccount, true);
    });

    test("A Bank Account can create empty placeholder", () {
      var bankAccount = BankAccount.empty();
      expect(bankAccount is BankAccount, true);
    });

    test("A Bank Account converts string account type to AccountType", () {
      final Map<String, dynamic> json = MockResponses.generateBankAccount();
      var bankAccount = BankAccount.fromJson(json: json);
      expect(bankAccount.accountType is AccountType, true);
    });

    test("A Bank Account converts Account Type to string", () {
      final Map<String, dynamic> json = MockResponses.generateBankAccount();
      var bankAccount = BankAccount.fromJson(json: json);
      expect(bankAccount.accountType is AccountType, true);
      expect(BankAccount.accountTypeToString(accountType: bankAccount.accountType) is String, true);
    });
  });
}