import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../status.dart';
import 'bank_account.dart';
import 'business_account.dart';
import 'owner_account.dart';

@immutable
class Accounts extends Equatable {
  final BusinessAccount businessAccount;
  final List<OwnerAccount> ownerAccounts;
  final BankAccount bankAccount;
  final Status accountStatus;

  const Accounts({
    required this.businessAccount,
    required this.ownerAccounts,
    required this.bankAccount,
    required this.accountStatus
  });

  Accounts.fromJson({required Map<String, dynamic> json})
    : businessAccount = json['business_account'] != null
        ? BusinessAccount.fromJson(json: json['business_account']!) 
        : BusinessAccount.empty(),
      ownerAccounts = json['owner_accounts'] != null 
        ? (json['owner_accounts']! as List)
          .map((jsonOwnerAccount) => OwnerAccount.fromJson(json: jsonOwnerAccount))
          .toList() 
        : [],
      bankAccount = json['bank_account'] != null 
        ? BankAccount.fromJson(json: json['bank_account']) 
        : BankAccount.empty(),
      accountStatus = json['account_status'] != null 
        ? Status.fromJson(json: json['account_status']) 
        : Status.unknown();

  factory Accounts.empty() => Accounts(
    businessAccount: BusinessAccount.empty(),
    ownerAccounts: const [],
    bankAccount: BankAccount.empty(),
    accountStatus: Status.unknown()
  );

  Accounts update({
    BusinessAccount? businessAccount,
    List<OwnerAccount>? ownerAccounts,
    BankAccount? bankAccount,
    Status? accountStatus,
  }) {
    return Accounts(
      businessAccount: businessAccount ?? this.businessAccount, 
      ownerAccounts: ownerAccounts ?? this.ownerAccounts, 
      bankAccount: bankAccount ?? this.bankAccount, 
      accountStatus: accountStatus ?? this.accountStatus
    );
  }

  @override
  List<Object> get props => [
    businessAccount,
    ownerAccounts,
    bankAccount,
    accountStatus,
  ];

  @override
  String toString() => '''Accounts {
    businessAccount: $businessAccount,
    ownerAccounts: $ownerAccounts,
    bankAccount: $bankAccount,
    accountStatus: $accountStatus
  }''';
}