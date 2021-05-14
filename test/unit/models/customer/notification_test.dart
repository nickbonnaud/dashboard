import 'package:dashboard/models/customer/notification.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Notification Tests", () {

    test("A Notification can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateNotification();
      var notification = Notification.fromJson(json: json);
      expect(notification is Notification, true);
    });

    test("A Notification converts last notification to human readable", () {
      var notification = Notification.fromJson(json: MockResponses.generateNotification());
      final String original = notification.last;
      final String cleaned = notification.lastNotification;
      expect(original != cleaned, true);

      expect(original.contains("_"), true);
      expect(original.contains(" "), false);

      expect(cleaned.contains("_"), false);
      expect(cleaned.contains(" "), true);
    });
  });
}