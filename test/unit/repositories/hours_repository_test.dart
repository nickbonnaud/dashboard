import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/providers/hours_provider.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHoursProvider extends Mock implements HoursProvider {}

void main() {
  group("Hours Repository Tests", () {
    late HoursRepository _hoursRepository;
    late HoursProvider _mockHoursProvider;
    late HoursRepository _hoursRepositoryWithMock;

    setUp(() {
      _hoursRepository = HoursRepository(hoursProvider: HoursProvider());
      _mockHoursProvider = MockHoursProvider();
      _hoursRepositoryWithMock = HoursRepository(hoursProvider: _mockHoursProvider);
      registerFallbackValue<Map<String, dynamic>>(Map());
    });
    
    test("Hours Repository can Store businesses hours", () async {
      final String hour = "9:00 AM - 10:00 PM";
      var hours = await _hoursRepository.store(sunday: hour, monday: hour, tuesday: hour, wednesday: hour, thursday: hour, friday: hour, saturday: hour);
      expect(hours is Hours, true);
    });

    test("Hours Repository throws error on Store business hours fail", () async {
      final String hour = "9:00 AM - 10:00 PM";
      when(() => _mockHoursProvider.store(body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _hoursRepositoryWithMock.store(sunday: hour, monday: hour, tuesday: hour, wednesday: hour, thursday: hour, friday: hour, saturday: hour), 
        throwsA(isA<ApiException>())
      );
    });

    test("Hours Repository can Update Business Hours", () async {
      final String hour = "8:00 AM - 10:00 PM";
      final String identifier = faker.guid.guid();
      var hours = await _hoursRepository.update(identifier: identifier, sunday: hour, monday: hour, tuesday: hour, wednesday: hour, thursday: hour, friday: hour, saturday: hour);
      expect(hours is Hours, true);
    });

    test("Hours Repository throws error on Update business hours fail", () async {
      final String hour = "8:00 AM - 10:00 PM";
      final String identifier = faker.guid.guid();
      when(() => _mockHoursProvider.update(identifier: identifier, body: any(named: "body"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _hoursRepositoryWithMock.update(identifier: identifier, sunday: hour, monday: hour, tuesday: hour, wednesday: hour, thursday: hour, friday: hour, saturday: hour), 
        throwsA(isA<ApiException>())
      );
    });
  });
}