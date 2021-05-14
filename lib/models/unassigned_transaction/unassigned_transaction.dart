import 'package:dashboard/models/business/employee.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'transaction.dart';

@immutable
class UnassignedTransaction extends Equatable {
  final Transaction transaction;
  final Employee? employee;

  const UnassignedTransaction({required this.transaction, this.employee});

  UnassignedTransaction.fromJson({required Map<String, dynamic> json})
    : transaction = Transaction.fromJson(json: json['transaction']),
      employee = json['employee'] != null
        ? Employee.fromJson(json: json['employee'])
        : null;

  @override
  List<Object?> get props => [transaction, employee];

  @override
  String toString() => 'UnassignedTransaction { transaction: $transaction, employee: $employee }';
}