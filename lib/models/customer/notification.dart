import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:dashboard/extensions/string_extensions.dart';

@immutable
class Notification extends Equatable {
  final String last;
  final bool exitSent;
  final DateTime? timeExitSent;
  final bool billClosedSent;
  final DateTime? timeBillClosedSent;
  final bool autoPaidSent;
  final DateTime? timeAutoPaidSent;
  final bool fixBillSent;
  final DateTime? timeFixBillSent;
  final int numberTimesFixBillSent;
  final DateTime updatedAt;

  Notification({
    required this.last,
    required this.exitSent,
    this.timeExitSent,
    required this.billClosedSent,
    this.timeBillClosedSent,
    required this.autoPaidSent,
    this.timeAutoPaidSent,
    required this.fixBillSent,
    this.timeFixBillSent,
    required this.numberTimesFixBillSent,
    required this.updatedAt
  });

  String get lastNotification => last.replaceAll("_", " ").capitalizeFirstEach;

  Notification.fromJson({required Map<String, dynamic> json})
    : last = json['last']!,
      exitSent = json['exit_sent']!,
      timeExitSent = DateFormatter.toDateTime(date: json['time_exit_sent']),
      billClosedSent = json['bill_closed_sent']!,
      timeBillClosedSent = DateFormatter.toDateTime(date: json['time_bill_closed_sent']),
      autoPaidSent = json['auto_paid_sent']!,
      timeAutoPaidSent = DateFormatter.toDateTime(date: json['time_auto_paid_sent']),
      fixBillSent = json['fix_bill_sent']!,
      timeFixBillSent = DateFormatter.toDateTime(date: json['time_fix_bill_sent']),
      numberTimesFixBillSent = json['number_times_fix_bill_sent']!,
      updatedAt = DateFormatter.toDateTime(date: json['updated_at']!);

  @override
  List<Object?> get props => [
    last,
    exitSent,
    timeExitSent,
    billClosedSent,
    timeBillClosedSent,
    autoPaidSent,
    timeAutoPaidSent,
    fixBillSent,
    timeFixBillSent,
    numberTimesFixBillSent,
    updatedAt
  ];

  @override
  String toString() => '''Notification {
    last: $last,
    exitSent: $exitSent,
    timeExitSent: $timeExitSent,
    billClosedSent: $billClosedSent,
    timeBillClosedSent: $timeBillClosedSent,
    autoPaidSent: $autoPaidSent,
    timeAutoPaidSent: $timeAutoPaidSent,
    fixBillSent: $fixBillSent,
    timeFixBillSent: $timeFixBillSent,
    numberTimesFixBillSent: $numberTimesFixBillSent,
    updatedAt: $updatedAt
  }''';
}