import 'package:dashboard/models/customer/customer_resource.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/customer_provider.dart';
import 'package:flutter/material.dart';

import 'base_repository.dart';

class CustomerRepository extends BaseRepository{
  late CustomerProvider _customerProvider;

  CustomerRepository({required CustomerProvider customerProvider})
    : _customerProvider = customerProvider;
  
  Future<PaginateDataHolder> fetchAll({required bool searchHistoric, required bool withTransactions, DateTimeRange? dateRange}) async {
    final String searchHistoricQuery = searchHistoric ? 'status=historic' : 'status=active';
    final String withTransactionsQuery = 'withTransaction=$withTransactions';
    final String query = this.formatQuery(baseQuery: "$searchHistoricQuery&$withTransactionsQuery", dateRange: dateRange);

    final PaginateDataHolder holder = await this.sendPaginated(request: _customerProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    final PaginateDataHolder holder = await this.sendPaginated(request: _customerProvider.fetchPaginated(paginateUrl: url));
    return deserialize(holder: holder);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((customer) => CustomerResource.fromJson(json: customer)).toList()
    );
  }
}