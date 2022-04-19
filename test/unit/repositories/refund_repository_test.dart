import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/models/refund/refund_resource.dart';
import 'package:dashboard/providers/refund_provider.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRefundProvider extends Mock implements RefundProvider {}

void main() {
  group("Refund Repository Tests", () {
    late RefundRepository _refundRepository;
    late RefundProvider _mockRefundProvider;
    late RefundRepository _refundRepositoryWithMock;

    setUp(() {
      _refundRepository = const RefundRepository();
      _mockRefundProvider = MockRefundProvider();
      _refundRepositoryWithMock = RefundRepository(refundProvider: _mockRefundProvider);
    });
    
    test("Refund Repository can Fetch All Refunds", () async {
      var refundPaginateData = await _refundRepository.fetchAll();
      expect(refundPaginateData, isA<PaginateDataHolder>());
      expect(refundPaginateData.data is List<RefundResource>, true);
      expect(refundPaginateData.data.isNotEmpty, true);
    });

    test("Refund Repository can Fetch All, queries: dateRange", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      var refundPaginateData = await _refundRepository.fetchAll(dateRange: dateRange);
      expect(refundPaginateData, isA<PaginateDataHolder>());
      expect(refundPaginateData.data is List<RefundResource>, true);
      expect(refundPaginateData.data.isNotEmpty, true);
    });

    test("Refund Repository throw error on Fetch All refunds fail", () async {
      when(() => _mockRefundProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      expect(
        _refundRepositoryWithMock.fetchAll(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can Fetch By Customer Name, queries: firstName, lastName", () async {
      String firstName = faker.person.firstName();
      String lastName = faker.person.lastName();
      var refundPaginateData = await _refundRepository.fetchByCustomerName(firstName: firstName, lastName: lastName);
      expect(refundPaginateData, isA<PaginateDataHolder>());
      expect(refundPaginateData.data is List<RefundResource>, true);
      expect(refundPaginateData.data.isNotEmpty, true);
    });

    test("Refund Repository can Fetch By Customer Name, queries: firstName", () async {
      String firstName = faker.person.firstName();
      var refundPaginateData = await _refundRepository.fetchByCustomerName(firstName: firstName);
      expect(refundPaginateData, isA<PaginateDataHolder>());
      expect(refundPaginateData.data is List<RefundResource>, true);
      expect(refundPaginateData.data.isNotEmpty, true);
    });

    test("Refund Repository can Fetch By Customer Name, queries: lastName", () async {
      String lastName = faker.person.lastName();
      var refundPaginateData = await _refundRepository.fetchByCustomerName(lastName: lastName);
      expect(refundPaginateData, isA<PaginateDataHolder>());
      expect(refundPaginateData.data is List<RefundResource>, true);
      expect(refundPaginateData.data.isNotEmpty, true);
    });

    test("Refund Repository can Fetch By Customer Name, queries: firstName, lastName, dateRange", () async {
      String firstName = faker.person.firstName();
      String lastName = faker.person.lastName();
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      var refundPaginateData = await _refundRepository.fetchByCustomerName(firstName: firstName, lastName: lastName, dateRange: dateRange);
      expect(refundPaginateData, isA<PaginateDataHolder>());
      expect(refundPaginateData.data is List<RefundResource>, true);
      expect(refundPaginateData.data.isNotEmpty, true);
    });

    test("Refund Repository throw error on Fetch By Customer Name fail", () async {
      String firstName = faker.person.firstName();
      String lastName = faker.person.lastName();
      when(() => _mockRefundProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _refundRepositoryWithMock.fetchByCustomerName(firstName: firstName, lastName: lastName), 
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can Fetch By Refund ID", () async {
      final String refundId = faker.guid.guid();
      var refundPaginateData = await _refundRepository.fetchByRefundId(refundId: refundId);
      expect(refundPaginateData, isA<PaginateDataHolder>());
      expect(refundPaginateData.data is List<RefundResource>, true);
      expect(refundPaginateData.data.isNotEmpty, true);
    });

    test("Refund Repository throw error on Fetch By Refund ID fail", () async {
      final String refundId = faker.guid.guid();
      when(() => _mockRefundProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _refundRepositoryWithMock.fetchByRefundId(refundId: refundId), 
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can Fetch By Transaction ID", () async {
      final String transactionId = faker.guid.guid();
      var refundPaginateData = await _refundRepository.fetchByTransactionId(transactionId: transactionId);
      expect(refundPaginateData, isA<PaginateDataHolder>());
      expect(refundPaginateData.data is List<RefundResource>, true);
      expect(refundPaginateData.data.isNotEmpty, true);
    });

    test("Refund Repository throw error on Fetch By Transaction ID fail", () async {
      final String transactionId = faker.guid.guid();
      when(() => _mockRefundProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _refundRepositoryWithMock.fetchByTransactionId(transactionId: transactionId), 
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can Fetch By Customer ID", () async {
      final String customerId = faker.guid.guid();
      var refundPaginateData = await _refundRepository.fetchByCustomerId(customerId: customerId);
      expect(refundPaginateData, isA<PaginateDataHolder>());
      expect(refundPaginateData.data is List<RefundResource>, true);
      expect(refundPaginateData.data.isNotEmpty, true);
    });

    test("Refund Repository throw error on Fetch By Customer ID fail", () async {
      final String customerId = faker.guid.guid();
      when(() => _mockRefundProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _refundRepositoryWithMock.fetchByCustomerId(customerId: customerId), 
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can Paginate", () async {
      String url = "http://novapay.ai/api/business/refunds?page=2";
      var refundPaginateData = await _refundRepository.paginate(url: url);
      expect(refundPaginateData, isA<PaginateDataHolder>());
      expect(refundPaginateData.data is List<RefundResource>, true);
    });

    test("Refund Repository throw error on Paginate fail", () async {
      String url = "http://novapay.ai/api/business/refunds?page=2";
      when(() => _mockRefundProvider.fetchPaginated(paginateUrl: any(named: "paginateUrl"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _refundRepositoryWithMock.paginate(url: url), 
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can Fetch Total Refunds Today", () async {
      var refundsToday = await _refundRepository.fetchTotalRefundsToday();
      expect(refundsToday, isA<int>());
    });

    test("Refund Repository throws error on Fetch Total Refunds Today fail", () async {
      when(() => _mockRefundProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _refundRepositoryWithMock.fetchTotalRefundsToday(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can Fetch Total Refunds Month", () async {
      var refundsMonth = await _refundRepository.fetchTotalRefundsMonth();
      expect(refundsMonth, isA<int>());
    });

    test("Refund Repository throws error on Fetch Total Refunds Month fail", () async {
      when(() => _mockRefundProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _refundRepositoryWithMock.fetchTotalRefundsMonth(), 
        throwsA(isA<ApiException>())
      );
    });
  });
}