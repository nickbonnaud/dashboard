import 'package:dashboard/models/photo.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Hour tests", () {

    test("A Photo can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generatePhoto();
      var photo = Photo.fromJson(json: json);
      expect(photo, isA<Photo>());
    });

    test("A Photo can generate an empty placeholder", () {
      var photo = Photo.empty();
      expect(photo, isA<Photo>());
    });
  });
}