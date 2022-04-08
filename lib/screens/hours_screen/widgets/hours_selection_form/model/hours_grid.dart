import 'package:dashboard/models/hour.dart';
import 'package:flutter/material.dart';

@immutable
class HoursGrid {
  final List<List<bool>> operatingHoursGrid;
  final int rows;
  final int cols;

  const HoursGrid({required this.operatingHoursGrid, required this.rows, required this.cols});

  bool get allHoursSelected => !operatingHoursGrid.any((List<bool> hour) => hour.contains(false));
  bool get populated => operatingHoursGrid.any((hour) => hour.any((isOpen) => isOpen));
  
  factory HoursGrid.initial({required Hour operatingHoursRange}) {
    const int cols = 8;
    int rows = _setRows(operatingHoursRange: operatingHoursRange);
    return HoursGrid(
      cols: cols,
      rows: rows, 
      operatingHoursGrid: _setOperatingHoursGrid(rows: rows, cols: cols),
    );
  }

  bool isOpen({required int x, required int y}) {
    return operatingHoursGrid[x][y];
  }

  List<TimeOfDay> hoursList({required TimeOfDay earliestStart}) {
    return List.generate(rows - 1, (index) {
      TimeOfDay startHour = earliestStart;
      DateTime now = DateTime.now();
      DateTime openTime = DateTime(now.year, now.month, now.day, startHour.hour, startHour.minute < 30 ? 0 : 30);

      DateTime updatedTime = openTime.add(Duration(minutes: 30 * index));
      return startHour.replacing(hour: updatedTime.hour, minute: updatedTime.minute);
    });
  }

  static int _setRows({required Hour operatingHoursRange}) {    
    DateTime now = DateTime.now();
    DateTime closeTime = DateTime(now.year, now.month, operatingHoursRange.end.hour < operatingHoursRange.start.hour ? now.day + 1 : now.day, operatingHoursRange.end.hour, operatingHoursRange.end.minute);
    DateTime openTime = DateTime(now.year, now.month, now.day, operatingHoursRange.start.hour, operatingHoursRange.start.minute);
    return (closeTime.difference(openTime).inMinutes / 30 + 2).ceil();
  }

  static List<List<bool>> _setOperatingHoursGrid({required int rows, required int cols}) {
    return List.generate(rows, (_) => List.generate(cols, (_) => false), growable: false);
  }

  HoursGrid update({required int x, required int y, required bool selected}) {
    operatingHoursGrid[x][y] = selected;
    return HoursGrid(
      cols: cols, 
      rows: rows, 
      operatingHoursGrid: operatingHoursGrid
    );
  }

  HoursGrid toggle() {
    return HoursGrid(
      cols: cols,
      rows: rows,
      operatingHoursGrid: operatingHoursGrid.map((List<bool> hours) => hours.map((bool hour) => !allHoursSelected).toList()).toList()
    );
  }

  @override
  String toString() => "HoursGrid: { operatingHoursGrid: $operatingHoursGrid, cols: $cols, rows: $rows }";
}