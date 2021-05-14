import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'address.dart';

enum AccountType {
  checking,
  saving,
  unknown
}

@immutable
class BankAccount extends Equatable {
  final String identifier;
  final String firstName;
  final String lastName;
  final String routingNumber;
  final String accountNumber;
  final AccountType accountType;
  final Address address;

  BankAccount({
    required this.identifier,
    required this.firstName,
    required this.lastName,
    required this.routingNumber,
    required this.accountNumber,
    required this.accountType,
    required this.address
  });

  BankAccount.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      firstName = json['first_name']!,
      lastName = json['last_name']!,
      routingNumber = json['routing_number']!,
      accountNumber = json['account_number']!,
      accountType = _stringToAccountType(accountTypeString: json['account_type']!),
      address = Address.fromJson(json: json['address']!);

  factory BankAccount.empty() => BankAccount(
    identifier: "",
    firstName: "",
    lastName: "",
    routingNumber: "",
    accountNumber: "",
    accountType: AccountType.unknown,
    address: Address.empty()
  );

  static AccountType _stringToAccountType({required String accountTypeString}) {
    return AccountType.values.firstWhere((accountType) {
      return accountType.toString().substring(accountType.toString().indexOf('.') + 1).toLowerCase() == accountTypeString.toLowerCase();
    });
  }

  static String accountTypeToString({required AccountType accountType}) {
    return accountType.toString().substring(accountType.toString().indexOf('.') + 1).toLowerCase();
  }

  @override
  List<Object> get props => [
    identifier,
    firstName,
    lastName,
    routingNumber,
    accountNumber,
    accountType,
    address
  ];

  @override
  String toString() => '''BankAccount {
    identifier: $identifier,
    firstName: $firstName,
    lastName: $lastName,
    routingNumber: $routingNumber,
    accountNumber: $accountNumber,
    accountType: $accountType,
    address: $address
  }''';
}