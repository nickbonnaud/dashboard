import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/refund/refund_resource.dart';
import 'package:dashboard/providers/refund_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:flutter/material.dart';

class RefundRepository extends BaseRepository {
  final RefundProvider? _refundProvider;

  const RefundRepository({RefundProvider? refundProvider})
    : _refundProvider = refundProvider;

  Future<PaginateDataHolder> fetchAll({DateTimeRange? dateRange}) async {
    String query = formatDateQuery(dateRange: dateRange);
    query = query.isNotEmpty ? query.replaceFirst("&", "?") : "";
    
    RefundProvider refundProvider = _getRefundProvider();
    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByCustomerName({String? firstName, String? lastName, DateTimeRange? dateRange}) async {
    String firstNameQuery = (firstName == null || firstName.isEmpty) ? "" : "customerFirst=$firstName";
    String lastNameQuery = (lastName == null || lastName.isEmpty) ? "" : "&customerLast=$lastName";
    String fullNameQuery = firstNameQuery.isEmpty ? lastNameQuery.substring(1) : "$firstNameQuery$lastNameQuery";
    
    String query = formatQuery(baseQuery: fullNameQuery, dateRange: dateRange);
    
    RefundProvider refundProvider = _getRefundProvider();
    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByRefundId({required String refundId}) async {
    String query = "?id=$refundId";
    
    RefundProvider refundProvider = _getRefundProvider();
    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetchPaginated(query: query));

    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByTransactionId({required String transactionId}) async {
    String query = "?transactionId=$transactionId";
    
    RefundProvider refundProvider = _getRefundProvider();
    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetchPaginated(query: query));

    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByCustomerId({required String customerId, DateTimeRange? dateRange}) async {
    String query = formatQuery(baseQuery: "customer=$customerId", dateRange: dateRange);
    
    RefundProvider refundProvider = _getRefundProvider();
    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetchPaginated(query: query));

    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    RefundProvider refundProvider = _getRefundProvider();

    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetchPaginated(paginateUrl: url));
    return deserialize(holder: holder);
  }
  
  Future<int> fetchTotalRefundsToday() async {
    DateTime now = DateTime.now();
    DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );
    String query = formatQuery(baseQuery: "sum=total", dateRange: dateRange);

    RefundProvider refundProvider = _getRefundProvider();
    Map<String, dynamic> json = await send(request: refundProvider.fetch(query: query));
    return json['refund_data'];
  }

  Future<int> fetchTotalRefundsMonth() async {
    DateTime now = DateTime.now();
    
    DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month - 1, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );

    String query = formatQuery(baseQuery: 'sum=total', dateRange: dateRange);

    RefundProvider refundProvider = _getRefundProvider();
    Map<String, dynamic> json = await send(request: refundProvider.fetch(query: query));
    return json['refund_data'];
  }
  
  RefundProvider _getRefundProvider() {
    return _refundProvider ?? const RefundProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((refund) => RefundResource.fromJson(json: refund)).toList()
    );
  }
}