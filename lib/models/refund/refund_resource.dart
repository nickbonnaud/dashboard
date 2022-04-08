import 'package:dashboard/models/refund/refund.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class RefundResource extends Equatable {
  final Refund refund;
  final TransactionResource transactionResource;

  const RefundResource({required this.refund, required this.transactionResource});

  RefundResource.fromJson({required Map<String, dynamic> json})
    : refund = Refund.fromJson(json: json['refund']!),
      transactionResource = TransactionResource.fromJson(json: json['transaction_resource']!);

  // RefundResource update({Refund? refund, TransactionResource? transactionResource}) {
  //   return RefundResource(
  //     refund: refund ?? this.refund, 
  //     transactionResource: transactionResource ?? this.transactionResource
  //   );
  // }
  
  @override
  List<Object> get props => [refund, transactionResource];

  @override
  String toString() => 'RefundResource { refund: $refund, transactionResource: $transactionResource }';
}