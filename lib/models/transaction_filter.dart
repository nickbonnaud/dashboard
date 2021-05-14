import 'package:meta/meta.dart';

enum FilterType { all, status, customerId, customerName, employeeName, transactionId, refundId, reset }

@immutable
class TransactionFilter {
  final FilterType value;
  final String title;

  const TransactionFilter({required this.value, required this.title});

  @override
  String toString() => 'TransactionFilter { value: $value, title: $title }';
}