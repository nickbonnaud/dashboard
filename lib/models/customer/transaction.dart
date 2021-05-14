import 'package:dashboard/models/refund/refund.dart';
import 'package:dashboard/models/transaction/purchased_item.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../status.dart';

@immutable
class Transaction extends Equatable {
  final String identifier;
  final int tax;
  final int tip;
  final int netSales;
  final int total;
  final int partialPayments;
  final bool locked;
  final DateTime billCreatedAt;
  final DateTime updatedAt;
  final Status status;
  final List<PurchasedItem> purchasedItems;
  final List<Refund> refunds;

  Transaction({
    required this.identifier,
    required this.tax,
    required this.tip,
    required this.netSales,
    required this.total,
    required this.partialPayments,
    required this.locked,
    required this.billCreatedAt,
    required this.updatedAt,
    required this.status,
    required this.purchasedItems,
    required this.refunds
  });

  Transaction.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      tax = json['tax']!,
      tip = json['tip']!,
      netSales = json['net_sales']!,
      total = json['total']!,
      partialPayments = int.parse(json['partial_payment']!),
      locked = json['locked']!,
      billCreatedAt = DateFormatter.toDateTime(date: json['bill_created_at']!),
      updatedAt = DateFormatter.toDateTime(date: json['updated_at']!),
      status = Status.fromJson(json: json['status']!),
      purchasedItems = (json['purchased_items']! as List)
        .map((jsonPurchasedItem) => PurchasedItem.fromJson(json: jsonPurchasedItem))
        .toList(),
      refunds = (json['refunds']! as List)
        .map((jsonRefunds) => Refund.fromJson(json: jsonRefunds))
        .toList();

  @override
  List<Object> get props => [
    identifier,
    tax,
    tip,
    netSales,
    total,
    partialPayments,
    locked,
    billCreatedAt,
    updatedAt,
    status,
    purchasedItems,
    refunds
  ];

  @override
  String toString() => '''Transaction {
    identifier: $identifier,
    tax: $tax,
    tip: $tip,
    netSales: $netSales,
    total: $total,
    partialPayments: $partialPayments,
    locked: $locked,
    billCreatedAt: $billCreatedAt,
    updatedAt: $updatedAt,
    status: $status,
    purchasedItems: $purchasedItems,
    refunds: $refunds
  }''';
}