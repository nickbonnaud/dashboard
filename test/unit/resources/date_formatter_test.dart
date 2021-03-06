import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Date Formatter Tests", () {

    test("Date Formatter parses string to DateTime", () {
      String dateTimeString = DateTime.now().toIso8601String();
      expect(DateFormatter.toDateTime(date: dateTimeString), isA<DateTime>());
    });

    test("Date Formatter parses DateTime to string with time", () {
      DateTime dateTime = DateTime.now();
      expect(DateFormatter.toStringDateTime(date: dateTime), isA<String>());
      expect(DateFormatter.toStringDateTime(date: dateTime).contains(" AM") || DateFormatter.toStringDateTime(date: dateTime).contains(" PM"), true);
    });

    test("Date Formatter parses DateTime to string without time", () {
      DateTime dateTime = DateTime.now();
      expect(DateFormatter.toStringDate(date: dateTime), isA<String>());
      expect(DateFormatter.toStringDate(date: dateTime).contains(" AM") || DateFormatter.toStringDate(date: dateTime).contains(" PM"), false);
    });
  });
}