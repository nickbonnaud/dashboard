import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/providers/transaction_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:flutter/material.dart';

class TransactionRepository extends BaseRepository {
  final TransactionProvider _transactionProvider;

  TransactionRepository({required TransactionProvider transactionProvider})
    : _transactionProvider = transactionProvider;

  Future<PaginateDataHolder> fetchAll({DateTimeRange? dateRange}) async {
    String query = formatDateQuery(dateRange: dateRange);
    query = query.isNotEmpty ? query.replaceFirst("&", "?") : "";
    
    final PaginateDataHolder holder = await sendPaginated(request: _transactionProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByCode({required int code, DateTimeRange? dateRange}) async {
    final String query = formatQuery(baseQuery: "status=$code", dateRange: dateRange);
    final PaginateDataHolder holder = await sendPaginated(request: _transactionProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByCustomerId({required String customerId, DateTimeRange? dateRange}) async {
    final String query = formatQuery(baseQuery: "customer=$customerId", dateRange: dateRange);
    final PaginateDataHolder holder = await sendPaginated(request: _transactionProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByCustomerName({String? firstName, String? lastName, DateTimeRange? dateRange}) async {
    final String firstNameQuery = (firstName == null || firstName.isEmpty) ? "" : "customerFirst=$firstName";
    final String lastNameQuery = (lastName == null || lastName.isEmpty) ? "" : "&customerLast=$lastName";
    final String fullNameQuery = firstNameQuery.isEmpty ? lastNameQuery.substring(1) : "$firstNameQuery$lastNameQuery";
    
    final String query = formatQuery(baseQuery: fullNameQuery, dateRange: dateRange);
    final PaginateDataHolder holder = await sendPaginated(request: _transactionProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByEmployeeName({String? firstName, String? lastName, DateTimeRange? dateRange}) async {
    final String firstNameQuery = (firstName == null || firstName.isEmpty) ? "" : "employeeFirst=$firstName";
    final String lastNameQuery = (lastName == null || lastName.isEmpty) ? "" : "&employeeLast=$lastName";
    final String fullNameQuery = firstNameQuery.isEmpty ? lastNameQuery.substring(1) : "$firstNameQuery$lastNameQuery";
    
    final String query = formatQuery(baseQuery: fullNameQuery, dateRange: dateRange);
    final PaginateDataHolder holder = await sendPaginated(request: _transactionProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByTransactionId({required String transactionId}) async {
    final String query = "?id=$transactionId";
    final PaginateDataHolder holder = await sendPaginated(request: _transactionProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    final PaginateDataHolder holder = await sendPaginated(request: _transactionProvider.fetchPaginated(paginateUrl: url));
    return deserialize(holder: holder);
  }
  
  Future<int> fetchNetSalesToday() async {
    final DateTime now = DateTime.now();
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day), 
      end: DateTime(now.year, now.month, now.day + 1)
    );
    final String query = formatQuery(baseQuery: "sum=net_sales", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchTotalTipsToday() async {
    final DateTime now = DateTime.now();
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );
    final String query = formatQuery(baseQuery: "sum=tip", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchTotalSalesToday() async {
    final DateTime now = DateTime.now();
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );
    final String query = formatQuery(baseQuery: "sum=total", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchTotalTaxesToday() async {
    final DateTime now = DateTime.now();
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );
    final String query = formatQuery(baseQuery: "sum=tax", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchNetSalesMonth() async {
    final DateTime now = DateTime.now();
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month - 1, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );
    final String query = formatQuery(baseQuery: "sum=net_sales", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchTotalTaxesMonth() async {
    final DateTime now = DateTime.now();
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month - 1, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );
    final String query = formatQuery(baseQuery: "sum=tax", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchTotalTipsMonth() async {
    final DateTime now = DateTime.now();
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month - 1, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );
    final String query = formatQuery(baseQuery: "sum=tip", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchNetSalesDateRange({@required DateTimeRange? dateRange}) async {
    final String query = formatQuery(baseQuery: "sum=net_sales", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchTotalSalesDateRange({@required DateTimeRange? dateRange}) async {
    final String query = formatQuery(baseQuery: "sum=total", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }
  
  Future<int> fetchTotalTipsDateRange({@required DateTimeRange? dateRange}) async {
    final String query = formatQuery(baseQuery: "sum=tip", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchTotalTaxesDateRange({@required DateTimeRange? dateRange}) async {
    final String query = formatQuery(baseQuery: "sum=tax", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchTotalSalesMonth() async {
    final DateTime now = DateTime.now();
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month - 1, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );
    final String query = formatQuery(baseQuery: "sum=total", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchTotalUniqueCustomersMonth() async {
    final DateTime now = DateTime.now();
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month - 1, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );
    final String query = formatQuery(baseQuery: "unique=customer_id&count=customer_id", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  Future<int> fetchTotalTransactionsMonth() async {
    final DateTime now = DateTime.now();
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month - 1, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );
    final String query = formatQuery(baseQuery: "count=''", dateRange: dateRange);

    final Map<String, dynamic> response = await send(request: _transactionProvider.fetch(query: query));
    return response['sales_data'];
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((transaction) => TransactionResource.fromJson(json: transaction)).toList()
    );
  }
}