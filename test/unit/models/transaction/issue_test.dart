import 'package:dashboard/models/transaction/issue.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Issue Tests", () {

    test("An Issue can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateIssue();
      var issue = Issue.fromJson(json: json);
      expect(issue, isA<Issue>());
    });

    test("An Issue converts string Issue Type to IssueType", () {
      var issue = Issue.fromJson(json: MockResponses.generateIssue());
      expect(issue.type, isA<IssueType>());
    });
  });
}