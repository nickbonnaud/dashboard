import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/providers/transaction_provider.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionProvider extends Mock implements TransactionProvider {}

void main() {
  group("Transaction Repository Tests", () {
    late TransactionRepository _transactionRepository;
    late TransactionProvider _mockTransactionProvider;
    late TransactionRepository _transactionRepositoryWithMock;

    setUp(() {
      _transactionRepository = TransactionRepository(transactionProvider: TransactionProvider());
      _mockTransactionProvider = MockTransactionProvider();
      _transactionRepositoryWithMock = TransactionRepository(transactionProvider: _mockTransactionProvider);
    });
    
    test("Transaction Repository can Fetch All", () async {
      var transactionData = await _transactionRepository.fetchAll();
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository can Fetch All, queries: dateRange", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      var transactionData = await _transactionRepository.fetchAll(dateRange: dateRange);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository throws error on Fetch All fail", () async {
      when(() => _mockTransactionProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _transactionRepositoryWithMock.fetchAll(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch By Code", () async {
      final int code = 200;
      var transactionData = await _transactionRepository.fetchByCode(code: code);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository can Fetch By Code, queries: dateRange", () async {
      final int code = 200;
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      
      var transactionData = await _transactionRepository.fetchByCode(code: code, dateRange: dateRange);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository throws error on Fetch By Code fail", () async {
      final int code = 200;
      when(() => _mockTransactionProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _transactionRepositoryWithMock.fetchByCode(code: code), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch By Customer ID", () async {
      final String customerId = faker.guid.guid();
      var transactionData = await _transactionRepository.fetchByCustomerId(customerId: customerId);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository can Fetch By Customer ID, queries: dateRange", () async {
      final String customerId = faker.guid.guid();
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);

      var transactionData = await _transactionRepository.fetchByCustomerId(customerId: customerId, dateRange: dateRange);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository throws error on Fetch By Customer ID fail", () async {
      final String customerId = faker.guid.guid();
      when(() => _mockTransactionProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _transactionRepositoryWithMock.fetchByCustomerId(customerId: customerId), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch By Customer Name, queries: firstName, lastName", () async {
      final String firstName = faker.person.firstName();
      final String lastName = faker.person.lastName();

      var transactionData = await _transactionRepository.fetchByCustomerName(firstName: firstName, lastName: lastName);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository can Fetch By Customer Name, queries: firstName", () async {
      final String firstName = faker.person.firstName();

      var transactionData = await _transactionRepository.fetchByCustomerName(firstName: firstName);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository can Fetch By Customer Name, queries: lastName", () async {
      final String lastName = faker.person.lastName();

      var transactionData = await _transactionRepository.fetchByCustomerName(lastName: lastName);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository can Fetch By Customer Name, queries: firstName, lastName, dateRange", () async {
      final String firstName = faker.person.firstName();
      final String lastName = faker.person.lastName();
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);

      var transactionData = await _transactionRepository.fetchByCustomerName(firstName: firstName, lastName: lastName, dateRange: dateRange);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository throws error on Fetch By Customer Name fail", () async {
      final String firstName = faker.person.firstName();
      final String lastName = faker.person.lastName();
      when(() => _mockTransactionProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _transactionRepositoryWithMock.fetchByCustomerName(firstName: firstName, lastName: lastName), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch By Employee Name, queries: firstName, lastName", () async {
      final String firstName = faker.person.firstName();
      final String lastName = faker.person.lastName();

      var transactionData = await _transactionRepository.fetchByEmployeeName(firstName: firstName, lastName: lastName);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository can Fetch By Employee Name, queries: firstName", () async {
      final String firstName = faker.person.firstName();

      var transactionData = await _transactionRepository.fetchByEmployeeName(firstName: firstName);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository can Fetch By Employee Name, queries: lastName", () async {
      final String lastName = faker.person.lastName();

      var transactionData = await _transactionRepository.fetchByEmployeeName(lastName: lastName);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository can Fetch By Employee Name, queries: firstName, lastName, dateRange", () async {
      final String firstName = faker.person.firstName();
      final String lastName = faker.person.lastName();
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);

      var transactionData = await _transactionRepository.fetchByEmployeeName(firstName: firstName, lastName: lastName, dateRange: dateRange);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository throws error on Fetch By Employee Name fail", () async {
      final String firstName = faker.person.firstName();
      final String lastName = faker.person.lastName();
      when(() => _mockTransactionProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _transactionRepositoryWithMock.fetchByEmployeeName(firstName: firstName, lastName: lastName), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch By Transaction ID", () async {
      final String transactionId = faker.guid.guid();
      var transactionData = await _transactionRepository.fetchByTransactionId(transactionId: transactionId);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.length, 1);
    });

    test("Transaction Repository throws error on Fetch By Transaction ID fail", () async {
      final String transactionId = faker.guid.guid();
      when(() => _mockTransactionProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _transactionRepositoryWithMock.fetchByTransactionId(transactionId: transactionId), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Paginate", () async {
      final String url = "http://novapay.ai/api/business/transactions?page=2";
      var transactionData = await _transactionRepository.paginate(url: url);
      expect(transactionData, isA<PaginateDataHolder>());
      expect(transactionData.data is List<TransactionResource>, true);
      expect(transactionData.data.isNotEmpty, true);
    });

    test("Transaction Repository throws error on Paginate fail", () async {
      final String url = "http://novapay.ai/api/business/transactions?page=2";
      when(() => _mockTransactionProvider.fetchPaginated(paginateUrl: any(named: "paginateUrl"))).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _transactionRepositoryWithMock.paginate(url: url), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Net Sales Today", () async {
      var transactionData = await _transactionRepository.fetchNetSalesToday();
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throws error on Fetch Net Sales Today fail", () async {
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchNetSalesToday(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Total Sales Today", () async {
      var transactionData = await _transactionRepository.fetchTotalSalesToday();
      expect(transactionData, isA<int>());
    });
    
    test("Transaction Repository throws error on Fetch Total Sales Today fail", () async {
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchTotalSalesToday(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Total Taxes Today", () async {
      var transactionData = await _transactionRepository.fetchTotalTaxesToday();
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throws error on Fetch Total Taxes Today fail", () async {
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchTotalTaxesToday(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Net Sales Month", () async {
      var transactionData = await _transactionRepository.fetchNetSalesMonth();
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throws error on Fetch Net Sales Month Today fail", () async {
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchNetSalesMonth(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Total Taxes Month", () async {
      var transactionData = await _transactionRepository.fetchTotalTaxesMonth();
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throws error on Fetch Total Taxes Month fail", () async {
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchTotalTaxesMonth(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Total Tips Month", () async {
      var transactionData = await _transactionRepository.fetchTotalTipsMonth();
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throws error on Fetch Total Tips Month fail", () async {
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchTotalTipsMonth(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Net Sales Date Range", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      var transactionData = await _transactionRepository.fetchNetSalesDateRange(dateRange: dateRange);
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throws error on Fetch Net Sales Date Range fail", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchNetSalesDateRange(dateRange: dateRange), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Total Sales Date Range", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      var transactionData = await _transactionRepository.fetchTotalSalesDateRange(dateRange: dateRange);
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throw error on Fetch Total Sales Date Range fail", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchTotalSalesDateRange(dateRange: dateRange), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Total Tips Date Range", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      var transactionData = await _transactionRepository.fetchTotalTipsDateRange(dateRange: dateRange);
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throws error on Fetch Total Tips Date Range fail", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchTotalTipsDateRange(dateRange: dateRange), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Total Taxes Date Range", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      var transactionData = await _transactionRepository.fetchTotalTaxesDateRange(dateRange: dateRange);
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throws error on Fetch Total Taxes Date Range fail", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchTotalTaxesDateRange(dateRange: dateRange), 
        throwsA(isA<ApiException>())
      );
    });


    test("Transaction Repository can Fetch Total Sales Month", () async {
      var transactionData = await _transactionRepository.fetchTotalSalesMonth();
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throws error on Fetch Total Sales Month fail", () async {
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchTotalSalesMonth(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Total Unique Customers Month", () async {
      var transactionData = await _transactionRepository.fetchTotalUniqueCustomersMonth();
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throws error on Fetch Total Unique Customers Month fail", () async {
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchTotalUniqueCustomersMonth(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can Fetch Total Transactions Month", () async {
      var transactionData = await _transactionRepository.fetchTotalTransactionsMonth();
      expect(transactionData, isA<int>());
    });

    test("Transaction Repository throws error on Fetch Total Transactions Month fail", () async {
      when(() => _mockTransactionProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        _transactionRepositoryWithMock.fetchTotalTransactionsMonth(), 
        throwsA(isA<ApiException>())
      );
    });
  });
}