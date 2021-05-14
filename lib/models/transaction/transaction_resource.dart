import 'package:dashboard/models/business/employee.dart';
import 'package:dashboard/models/customer/customer.dart';
import 'package:dashboard/models/refund/refund.dart';
import 'package:dashboard/models/transaction/issue.dart';
import 'package:dashboard/models/transaction/purchased_item.dart';
import 'package:dashboard/models/transaction/transaction.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class TransactionResource extends Equatable {
  final Transaction transaction;
  final Customer customer;
  final Employee? employee;
  final List<Refund> refunds;
  final List<PurchasedItem> purchasedItems;
  final Issue? issue;

  TransactionResource({
    required this.transaction,
    required this.customer,
    this.employee,
    required this.refunds,
    required this.purchasedItems,
    this.issue
  });

  TransactionResource.fromJson({required Map<String, dynamic> json})
    : transaction = Transaction.fromJson(json: json['transaction']!),
      customer = Customer.fromJson(json: json['customer']!),
      employee = json['employee'] != null
        ? Employee.fromJson(json: json['employee'])
        : null,
      refunds = (json['refunds']! as List)
        .map((jsonRefunds) => Refund.fromJson(json: jsonRefunds))
        .toList(),
      purchasedItems = (json['purchased_items']! as List)
        .map((jsonPurchasedItem) => PurchasedItem.fromJson(json: jsonPurchasedItem))
        .toList(),
      issue = json['issue'] != null
        ? Issue.fromJson(json: json['issue'])
        : null;

  // TransactionResource update({
  //   Transaction? transaction,
  //   Customer? customer,
  //   Employee? employee,
  //   List<Refund>? refunds,
  //   List<PurchasedItem>? purchasedItems,
  //   Issue? issue
  // }) {
  //   return TransactionResource(
  //     transaction: transaction ?? this.transaction,
  //     customer: customer ?? this.customer,
  //     employee: employee ?? this.employee,
  //     refunds: refunds ?? this.refunds,
  //     purchasedItems: purchasedItems ?? this.purchasedItems,
  //     issue: issue ?? this.issue
  //   );
  // }

  @override
  List<Object?> get props => [
    transaction,
    customer,
    employee,
    refunds,
    purchasedItems,
    issue
  ];

  @override
  String toString() => '''TransactionResource {
    transaction: $transaction,
    customer: $customer,
    employee: $employee,
    refunds: $refunds,
    purchasedItems: $purchasedItems,
    issue: $issue
  }''';
}