import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/models/unassigned_transaction/unassigned_transaction.dart';
import 'package:dashboard/providers/unassigned_transaction_provider.dart';
import 'package:dashboard/repositories/unassigned_transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUnassignedTransactionProvider extends Mock implements UnassignedTransactionProvider {}

void main() {
  group("Unassigned Transaction Repository Tests", () {
    late UnassignedTransactionRepository _unassignedRepository;
    late UnassignedTransactionProvider _mockUnassignedTransactionProvider;
    late UnassignedTransactionRepository _unassignedTransactionProviderWithMock;

    setUp(() {
      _unassignedRepository = const UnassignedTransactionRepository(unassignedTransactionProvider: UnassignedTransactionProvider());
      _mockUnassignedTransactionProvider = MockUnassignedTransactionProvider();
      _unassignedTransactionProviderWithMock = UnassignedTransactionRepository(unassignedTransactionProvider: _mockUnassignedTransactionProvider);
    });
    
    test("Unassigned Transaction Repository can Fetch All", () async {
      var unassignedTransactionData = await _unassignedRepository.fetchAll();
      expect(unassignedTransactionData, isA<PaginateDataHolder>());
      expect(unassignedTransactionData.data is List<UnassignedTransaction>, true);
      expect(unassignedTransactionData.data.isNotEmpty, true);
    });

    test("Unassigned Transaction Repository can Fetch All, queries: dateRange ", () async {
      final DateTime now = DateTime.now();
      final DateTimeRange dateRange = DateTimeRange(start: DateTime(now.year, now.month, now.day - 7), end: now);

      var unassignedTransactionData = await _unassignedRepository.fetchAll(dateRange: dateRange);
      expect(unassignedTransactionData, isA<PaginateDataHolder>());
      expect(unassignedTransactionData.data is List<UnassignedTransaction>, true);
      expect(unassignedTransactionData.data.isNotEmpty, true);
    });

    test("Unassigned Transaction Repository throws error on Fetch All fail", () async {
      when(() => _mockUnassignedTransactionProvider.fetch(query: any(named: 'query'))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));

      expect(
        _unassignedTransactionProviderWithMock.fetchAll(), 
        throwsA(isA<ApiException>())
      );
    });

    test("Unassigned Transaction Repository can Paginate", () async {
      String url = "http://novapay.ai/api/business/unassigned-transactions?page=2";
      var unassignedTransactionData = await _unassignedRepository.paginate(url: url);
      expect(unassignedTransactionData, isA<PaginateDataHolder>());
      expect(unassignedTransactionData.data is List<UnassignedTransaction>, true);
      expect(unassignedTransactionData.data.isNotEmpty, true);
    });

    test("Unassigned Transaction Repository throws error on Paginate fail", () async {
      String url = "http://novapay.ai/api/business/unassigned-transactions?page=2";
      when(() => _mockUnassignedTransactionProvider.fetch(paginateUrl: any(named: 'paginateUrl'))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));

      expect(
        _unassignedTransactionProviderWithMock.paginate(url: url), 
        throwsA(isA<ApiException>())
      );
    });
  });
}