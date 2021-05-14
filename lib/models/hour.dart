import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Hour extends Equatable {
  final TimeOfDay start;
  final TimeOfDay end;

  Hour({required this.start, required this.end});

  Hour update({TimeOfDay? start, TimeOfDay? end}) {
    return Hour(
      start: start ?? this.start,
      end: end ?? this.end
    );
  }
  
  @override
  List<Object> get props => [start, end];

  @override
  String toString() => 'Hour { start: $start, end: $end }';
}