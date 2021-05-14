import 'package:dashboard/models/transaction/purchased_item.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Transaction extends Equatable {
  final String identifier;
  final int tax;
  final int netSales;
  final int total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PurchasedItem> purchasedItems;

  Transaction({
    required this.identifier,
    required this.tax,
    required this.netSales,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.purchasedItems
  });
  
  Transaction.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      tax = json['tax']!,
      netSales = json['net_sales']!,
      total = json['total']!,
      createdAt = DateFormatter.toDateTime(date: json['created_at']!),
      updatedAt = DateFormatter.toDateTime(date: json['updated_at']!),
      purchasedItems = (json['purchased_items']! as List)
        .map((jsonPurchasedItem) => PurchasedItem.fromJson(json: jsonPurchasedItem))
        .toList();

  @override
  List<Object> get props => [
    identifier,
    tax,
    netSales,
    total,
    createdAt,
    updatedAt,
    purchasedItems
  ];

  @override
  String toString() => '''Transaction {
    identifier: $identifier,
    tax: $tax,
    netSales: $netSales,
    total: $total,
    createdAt: $createdAt,
    updatedAt: $updatedAt,
    purchasedItems: $purchasedItems
  }''';
}