import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Reply Tests", () {

    test("A Reply can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateReply();
      var reply = Reply.fromJson(json: json);
      expect(reply, isA<Reply>());
    });

    test("A Reply can update it's attributes", () {
      var reply = Reply.fromJson(json: MockResponses.generateReply(index: 1, hasUnreadReply: true));
      final bool original = reply.read;
      expect(reply.read == original, true);
      reply = reply.update(read: !reply.read);
      expect(reply.read == original, false);
    });
  });
}