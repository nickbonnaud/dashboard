import 'package:dashboard/models/business/employee_tip.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/tips_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:flutter/material.dart';

class TipsRepository extends BaseRepository {
  late TipsProvider _tipsProvider;

  TipsRepository({required TipsProvider tipsProvider})
    : _tipsProvider = tipsProvider;

  Future<PaginateDataHolder> fetchAll({DateTimeRange? dateRange}) async {
    final String query = this.formatQuery(baseQuery: "employees=all", dateRange: dateRange);
    
    final PaginateDataHolder holder = await this.sendPaginated(request: _tipsProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<List<EmployeeTip>> fetchByCustomerName({String? firstName, String? lastName, DateTimeRange? dateRange}) async {
    final String firstNameQuery = (firstName == null || firstName.length == 0) ? "" : "customerFirst=$firstName";
    final String lastNameQuery = (lastName == null || lastName.length == 0) ? "" : "&customerLast=$lastName";
    final String fullNameQuery = firstNameQuery.length == 0 ? lastNameQuery.substring(1) : "$firstNameQuery$lastNameQuery";
    
    final String query = this.formatQuery(baseQuery: "employees=single&$fullNameQuery", dateRange: dateRange);
    final PaginateDataHolder holder = await this.sendPaginated(request: _tipsProvider.fetchPaginated(query: query));

    return holder.update(
      data: holder.data.map((tip) => EmployeeTip.fromJson(json: tip)).toList()
    ).data as List<EmployeeTip>;
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    final PaginateDataHolder holder = await this.sendPaginated(request: _tipsProvider.fetchPaginated(paginateUrl: url));
    return deserialize(holder: holder);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((tip) => EmployeeTip.fromJson(json: tip)).toList()
    );
  }
}