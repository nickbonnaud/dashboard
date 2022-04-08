import 'package:dashboard/models/status.dart';

class Constants {
  static const String appName = "Nova";

  static const List<String> states = [
    "AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC",  
    "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA",  
    "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE",  
    "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC",  
    "SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"
  ];

  static List<Status> defaultStatuses = [
    const Status(name: "Open", code: 100),
    const Status(name: "Closed", code: 101),
    const Status(name: "Payment Processing", code: 103),
    const Status(name: "Customer Approved", code: 104),
    const Status(name: "Keep Open Notification Sent", code: 105),
    const Status(name: "Customer Request Keep Open", code: 106),
    const Status(name: "Paid", code: 200),
    const Status(name: "Wrong Bill", code: 500),
    const Status(name: "Error in Bill", code: 501),
    const Status(name: "Error Notifying Customer", code: 502),
    const Status(name: "Other Error", code: 503),
  ];
}