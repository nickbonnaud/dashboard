import 'package:dashboard/models/business/pos_account.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dashboard/extensions/string_extensions.dart';

void main() {
  group("Pos Account Tests", () {

    test("A Pos Account can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generatePosAccount();
      var posAccount = PosAccount.fromJson(json: json);
      expect(posAccount is PosAccount, true);
    });

    test("A Pos Account can create an Empty placeholder", () {
      var posAccount = PosAccount.empty();
      expect(posAccount is PosAccount, true);
    });

    test("A Pos Account formats string type to PosType", () {
      final Map<String, dynamic> json = MockResponses.generatePosAccount();
      var posAccount = PosAccount.fromJson(json: json);
      expect(posAccount.type is PosType, true);
    });

    test("A Pos Account converts PosType to string", () {
      final Map<String, dynamic> json = MockResponses.generatePosAccount();
      final String type = json['type'];
      var posAccount = PosAccount.fromJson(json: json);
      expect(posAccount.typeToString is String, true);
      expect(posAccount.typeToString, type.capitalizeFirstEach);
    });
  });
}