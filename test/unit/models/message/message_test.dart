import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Message tests", () {

    test("A Message can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateMessage();
      var message = Message.fromJson(json: json);
      expect(message, isA<Message>());
    });

    test("A Message can update it's attributes", () {
      var message = Message.fromJson(json: MockResponses.generateMessage());
      final int originalRepliesNumber = message.replies.length;
      final Reply newReply = Reply.fromJson(json: MockResponses.generateReply());
      message = message.update(replies: message.replies..add(newReply));
      expect(originalRepliesNumber != message.replies.length, true);
    });

    test("A Message can check for unread", () {
      var message = Message.fromJson(json: MockResponses.generateMessage());
      expect(message.hasUnread, isA<bool>());
    });
  });
}