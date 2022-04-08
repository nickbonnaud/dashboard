import 'package:dashboard/models/customer/customer_resource.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/customer_provider.dart';
import 'package:dashboard/repositories/customer_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerProvider extends Mock implements CustomerProvider {}

void main() {
  group("Customer Repository Tests", () {
    late CustomerRepository _customerRepository;
    late CustomerProvider _mockCustomerProvider;
    late CustomerRepository _customerRepositoryWithMock;

    setUp(() {
      _customerRepository = CustomerRepository(customerProvider: CustomerProvider());
      _mockCustomerProvider = MockCustomerProvider();
      _customerRepositoryWithMock = CustomerRepository(customerProvider: _mockCustomerProvider);
    });
    
    test("Customer Repository can Fetch All customers, queries: historic, withoutTransaction", () async {
      var customersPaginateData = await _customerRepository.fetchAll(searchHistoric: true, withTransactions: false);
      expect(customersPaginateData, isA<PaginateDataHolder>());
      expect(customersPaginateData.data is List<CustomerResource>, true);
      expect(customersPaginateData.data.isNotEmpty, true);
    });

    test("Customer Repository can Fetch All customers, queries: active, withoutTransaction", () async {
      var customersPaginateData = await _customerRepository.fetchAll(searchHistoric: false, withTransactions: false);
      expect(customersPaginateData, isA<PaginateDataHolder>());
      expect(customersPaginateData.data is List<CustomerResource>, true);
      expect(customersPaginateData.data.isNotEmpty, true);
    });

    test("Customer Repository can Fetch All customers, queries: historic, withTransaction", () async {
      var customersPaginateData = await _customerRepository.fetchAll(searchHistoric: true, withTransactions: true);
      expect(customersPaginateData, isA<PaginateDataHolder>());
      expect(customersPaginateData.data is List<CustomerResource>, true);
      expect(customersPaginateData.data.isNotEmpty, true);
    });

    test("Customer Repository can Fetch All customers, queries: active, withTransaction", () async {
      var customersPaginateData = await _customerRepository.fetchAll(searchHistoric: false, withTransactions: true);
      expect(customersPaginateData, isA<PaginateDataHolder>());
      expect(customersPaginateData.data is List<CustomerResource>, true);
      expect(customersPaginateData.data.isNotEmpty, true);
    });

    test("Customer Repository can Fetch All customers, queries: historic, withTransaction, dateTime", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);
      var customersPaginateData = await _customerRepository.fetchAll(searchHistoric: true, withTransactions: true, dateRange: dateRange);
      expect(customersPaginateData, isA<PaginateDataHolder>());
      expect(customersPaginateData.data is List<CustomerResource>, true);
      expect(customersPaginateData.data.isNotEmpty, true);
    });

    test("Customer Repository throws error on Fetch All customers fail", () async {
      when(() => _mockCustomerProvider.fetchPaginated(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      expect(
        _customerRepositoryWithMock.fetchAll(searchHistoric: true, withTransactions: false),
        throwsA(isA<ApiException>())
      );
    });

    test("Customer Repository can Paginate", () async {
      String url = "http://novapay.ai/api/business/customers?page=2";
      var customersPaginateData = await _customerRepository.paginate(url: url);
      expect(customersPaginateData, isA<PaginateDataHolder>());
      expect(customersPaginateData.data is List<CustomerResource>, true);
    });

    test("Customer Repository throws error on Paginate fail", () async {
      String url = "http://novapay.ai/api/business/customers?page=2";
      when(() => _mockCustomerProvider.fetchPaginated(paginateUrl: any(named: "paginateUrl"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      expect(
        _customerRepositoryWithMock.paginate(url: url),
        throwsA(isA<ApiException>())
      );
    });
  });
}