import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@immutable
class Hours extends Equatable {
  final String identifier;
  final String sunday;
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final bool empty;

  Hours({
    required this.identifier,
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.empty
  });

  List<String> get days => [
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday
  ];

  String get earliest {
    List<String> hours = [
      this.sunday,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday
    ];
    var newHours = hours.where((hour) => hour.toLowerCase() != 'closed')
      .map((hour) => DateFormat.jm().parse(hour.substring(0,  hour.indexOf("-")))).toList()
      ..sort((hourOne, hourTwo) => hourOne.compareTo(hourTwo));
    return DateFormat('h:mm a').format(newHours.first);
  }

  String get latest {
    List<String> hours = [
      this.sunday,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday
    ];
    var newHours = hours.where((hour) => hour.toLowerCase() != 'closed')
      .map((hour) {
        final String strHour = hour.substring(hour.lastIndexOf("- ") + 2);
        DateTime formattedHour = DateFormat.jm().parse(strHour);
        if (strHour.toLowerCase().contains("am")) {
          formattedHour = formattedHour.add(Duration(days: 1));
        }
        return formattedHour;
      }).toList()
      ..sort((hourOne, hourTwo) => hourTwo.compareTo(hourOne));
    return DateFormat('h:mm a').format(newHours.first);
  }
  
  static Hours fromJson({required Map<String, dynamic> json}) {
    return Hours(
      sunday: json['sunday']!,
      identifier: json['identifier']!,
      monday: json['monday']!,
      tuesday: json['tuesday']!,
      wednesday: json['wednesday']!,
      thursday: json['thursday']!,
      friday: json['friday']!,
      saturday: json['saturday']!,
      empty: false
    );
  }

  factory Hours.empty() {
    return Hours(
      sunday: "",
      identifier: "",
      monday: "",
      tuesday: "",
      wednesday: "",
      thursday: "",
      friday: "",
      saturday: "",
      empty: true
    );
  }

  static TimeOfDay toTimeOfDay({required String time}) {
    return TimeOfDay.fromDateTime(DateFormat.jm().parse(time));
  }
  
  @override
  List<Object> get props => [identifier, sunday, monday, tuesday, wednesday, thursday, friday, saturday, empty];

  @override
  String toString() => 'Hours { identifier: $identifier, sunday: $sunday, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, empty: $empty }';
}