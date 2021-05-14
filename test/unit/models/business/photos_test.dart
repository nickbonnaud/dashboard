import 'package:dashboard/models/business/photos.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Photos Tests", () {

    test('Photos can deserialize json', () {
      final Map<String, dynamic> json = MockResponses.generatePhotos();
      var photos = Photos.fromJson(json: json);
      expect(photos is Photos, true);
    });

    test("Photos can create Empty placeholder", () {
      var photos = Photos.empty();
      expect(photos is Photos, true);
    });
  });
}