import 'package:dashboard/models/hour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Hour tests", () {

    test("An Hour can update it's attributes", () {
      final oldTime = TimeOfDay.now();
      Hour hour = Hour(start: oldTime, end: oldTime);
      expect(hour.end, oldTime);
      final newTime = TimeOfDay(hour: oldTime.hour + 1, minute: oldTime.minute + 1);
      hour = hour.update(end: newTime);
      expect(hour.end != oldTime, true);
      expect(hour.end, newTime);
    });
  });
}