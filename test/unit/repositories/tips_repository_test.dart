import 'package:dashboard/models/business/employee_tip.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/tips_provider.dart';
import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTipsProvider extends Mock implements TipsProvider {}

void main() {
  
  group("Tips Repository Tests", () {
    late TipsRepository _tipRepository;
    late TipsProvider _mockTipsProvider;
    late TipsRepository _tipRepositoryWithMock;

    setUp(() {
      _tipRepository = const TipsRepository(tipsProvider: TipsProvider());
      _mockTipsProvider = MockTipsProvider();
      _tipRepositoryWithMock = TipsRepository(tipsProvider: _mockTipsProvider);
    });
    
    test("Tips Repository can Fetch All Tips", () async {
      var tipsPaginateData = await _tipRepository.fetchAll();
      expect(tipsPaginateData, isA<PaginateDataHolder>());
      expect(tipsPaginateData.data is List<EmployeeTip>, true);
      expect(tipsPaginateData.data.isNotEmpty, true);
    });

    test("Tips Repository can Fetch All Tips, queries: dateRange", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      var tipsPaginateData = await _tipRepository.fetchAll(dateRange: dateRange);
      expect(tipsPaginateData, isA<PaginateDataHolder>());
      expect(tipsPaginateData.data is List<EmployeeTip>, true);
      expect(tipsPaginateData.data.isNotEmpty, true);
    });

    test("Tips Repository throws error on Fetch All Tips fail", () async {
      when(() => _mockTipsProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _tipRepositoryWithMock.fetchAll(),
        throwsA(isA<ApiException>())
      );
    });

    test("Tips Repository can Fetch By Customer Name, queries: firstName, lastName", () async {
      String firstName = faker.person.firstName();
      String lastName = faker.person.lastName();

      var tipsData= await _tipRepository.fetchByCustomerName(firstName: firstName, lastName: lastName);
      expect(tipsData, isA<List<EmployeeTip>>());
      expect(tipsData.isNotEmpty, true);
    });

    test("Tips Repository can Fetch By Customer Name, queries: lastName", () async {
      String lastName = faker.person.lastName();

      var tipsData= await _tipRepository.fetchByCustomerName(lastName: lastName);
      expect(tipsData, isA<List<EmployeeTip>>());
      expect(tipsData.isNotEmpty, true);
    });

    test("Tips Repository can Fetch By Customer Name, queries: firstName", () async {
      String firstName = faker.person.firstName();

      var tipsData= await _tipRepository.fetchByCustomerName(firstName: firstName);
      expect(tipsData, isA<List<EmployeeTip>>());
      expect(tipsData.isNotEmpty, true);
    });
    
    test("Tips Repository can Fetch By Customer Name, queries: firstName, lastName, dateRange", () async {
      String firstName = faker.person.firstName();
      String lastName = faker.person.lastName();
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);

      var tipsData = await _tipRepository.fetchByCustomerName(firstName: firstName, lastName: lastName, dateRange: dateRange);
      expect(tipsData, isA<List<EmployeeTip>>());
      expect(tipsData.isNotEmpty, true);
    });

    test("Tips Repository throws error on Fetch By Customer Name fail", () async {
      String firstName = faker.person.firstName();
      String lastName = faker.person.lastName();
      when(() => _mockTipsProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _tipRepositoryWithMock.fetchByCustomerName(firstName: firstName, lastName: lastName),
        throwsA(isA<ApiException>())
      );
    });

    test("Tips Repository can Paginate", () async {
      String url = "http://novapay.ai/api/business/tips?employees=all&page=2";
      var tipsData = await _tipRepository.paginate(url: url);
      expect(tipsData, isA<PaginateDataHolder>());
      expect(tipsData.data is List<EmployeeTip>, true);
    });

    test("Tips Repository throws error on Paginate fail", () async {
      String url = "http://novapay.ai/api/business/tips?employees=all&page=2";
      when(() => _mockTipsProvider.fetchPaginated(paginateUrl: any(named: "paginateUrl"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _tipRepositoryWithMock.paginate(url: url),
        throwsA(isA<ApiException>())
      );
    });
  });
}