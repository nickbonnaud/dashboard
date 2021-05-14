import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/refund/refund_resource.dart';
import 'package:dashboard/providers/refund_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:flutter/material.dart';

class RefundRepository extends BaseRepository {
  late RefundProvider _refundProvider;

  RefundRepository({required RefundProvider refundProvider})
    : _refundProvider = refundProvider;

  Future<PaginateDataHolder> fetchAll({DateTimeRange? dateRange}) async {
    String query = this.formatDateQuery(dateRange: dateRange);
    query = query.isNotEmpty ? query.replaceFirst("&", "?") : "";
    
    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByCustomerName({String? firstName, String? lastName, DateTimeRange? dateRange}) async {
    final String firstNameQuery = (firstName == null || firstName.length == 0) ? "" : "customerFirst=$firstName";
    final String lastNameQuery = (lastName == null || lastName.length == 0) ? "" : "&customerLast=$lastName";
    final String fullNameQuery = firstNameQuery.length == 0 ? lastNameQuery.substring(1) : "$firstNameQuery$lastNameQuery";
    
    final String query = this.formatQuery(baseQuery: fullNameQuery, dateRange: dateRange);
    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByRefundId({required String refundId}) async {
    final String query = "?id=$refundId";
    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetchPaginated(query: query));

    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByTransactionId({required String transactionId}) async {
    final String query = "?transactionId=$transactionId";
    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetchPaginated(query: query));

    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByCustomerId({required String customerId, DateTimeRange? dateRange}) async {
    final String query = this.formatQuery(baseQuery: "customer=$customerId", dateRange: dateRange);
    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetchPaginated(query: query));

    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetchPaginated(paginateUrl: url));
    return deserialize(holder: holder);
  }
  
  Future<int> fetchTotalRefundsToday() async {
    final DateTime now = DateTime.now();
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );
    final String query = this.formatQuery(baseQuery: "sum=total", dateRange: dateRange);

    final Map<String, dynamic> json = await this.send(request: _refundProvider.fetch(query: query));
    return json['refund_data'];
  }

  Future<int> fetchTotalRefundsMonth() async {
    final DateTime now = DateTime.now();
    
    final DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year, now.month - 1, now.day),
      end: DateTime(now.year, now.month, now.day + 1)
    );

    final String query = this.formatQuery(baseQuery: 'sum=total', dateRange: dateRange);

    final Map<String, dynamic> json = await this.send(request: _refundProvider.fetch(query: query));
    return json['refund_data'];
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((refund) => RefundResource.fromJson(json: refund)).toList()
    );
  }
}