import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class EmployeeTip extends Equatable {
  final String firstName;
  final String lastName;
  final int total;

  const EmployeeTip({required this.firstName, required this.lastName, required this.total});

  EmployeeTip.fromJson({required Map<String, dynamic> json})
    : firstName = json['first_name']!,
      lastName = json['last_name']!,
      total = json['tips']!;

  @override
  List<Object> get props => [firstName, lastName, total];

  @override
  String toString() => 'EmployeeTip { firstName: $firstName, lastname: $lastName, total" $total }';
}