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
  final DateTime createdAt;
  final DateTime updatedAt;
  final Status status;


  const Transaction({
    required this.identifier,
    required this.tax,
    required this.tip,
    required this.netSales,
    required this.total,
    required this.partialPayments,
    required this.locked,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  Transaction.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      tax = json['tax']!,
      tip = json['tip']!,
      netSales = json['net_sales']!,
      total = json['total']!,
      partialPayments = int.parse(json['partial_payment']!),
      locked = json['locked']!,
      createdAt = DateFormatter.toDateTime(date: json['bill_created_at']!),
      updatedAt = DateFormatter.toDateTime(date: json['updated_at']!),
      status = Status.fromJson(json: json['status']!);

  // Transaction update({
  //   String? identifier,
  //   int? tax,
  //   int? tip,
  //   int? netSales,
  //   int? total,
  //   int? partialPayments,
  //   bool? locked,
  //   DateTime? createdAt,
  //   DateTime? updatedAt,
  //   Status? status,
  // }) {
  //   return Transaction(
  //     identifier: identifier ?? this.identifier,
  //     tax: tax ?? this.tax,
  //     tip: tip ?? this.tip,
  //     netSales: netSales ?? this.netSales,
  //     total: total ?? this.total,
  //     partialPayments: partialPayments ?? this.partialPayments,
  //     locked: locked ?? this.locked,
  //     createdAt: createdAt ?? this.createdAt,
  //     updatedAt: updatedAt ?? this.updatedAt,
  //     status: status ?? this.status
  //   );
  // }

  @override
  List<Object> get props => [
    identifier,
    tax,
    tip,
    netSales,
    total,
    partialPayments,
    locked,
    createdAt,
    updatedAt,
    status
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
    createdAt: $createdAt,
    updatedAt: $updatedAt,
    status: $status
  }''';
}