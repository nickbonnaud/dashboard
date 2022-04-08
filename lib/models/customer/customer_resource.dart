import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'customer.dart';
import 'notification.dart';
import 'transaction.dart';

@immutable
class CustomerResource extends Equatable {
  final Customer customer;
  final Transaction? transaction;
  final Notification? notification;
  final DateTime enteredAt;

  const CustomerResource({
    required this.customer, 
    this.transaction, 
    this.notification, 
    required this.enteredAt
  });

  CustomerResource.fromJson({required Map<String, dynamic> json})
    : customer = Customer.fromJson(json: json['customer']!),
      transaction = json['transaction'] != null 
        ? Transaction.fromJson(json: json['transaction']) 
        : null,
      notification = json['notification'] != null 
        ? Notification.fromJson(json: json['notification'])
        : null,
      enteredAt = DateFormatter.toDateTime(date: json['entered_at']!);


  @override
  List<Object?> get props => [
    customer, 
    transaction, 
    notification, 
    enteredAt
  ];

  @override
  String toString() => 'CustomerResource { customer: $customer, transaction: $transaction, notification: $notification, enteredAt: $enteredAt }';
}