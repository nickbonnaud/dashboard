import 'package:dashboard/models/business/employee_tip.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/tips_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:flutter/material.dart';

class TipsRepository extends BaseRepository {
  final TipsProvider _tipsProvider;

  const TipsRepository({required TipsProvider tipsProvider})
    : _tipsProvider = tipsProvider;

  Future<PaginateDataHolder> fetchAll({DateTimeRange? dateRange}) async {
    String query = formatQuery(baseQuery: "employees=all", dateRange: dateRange);
    
    PaginateDataHolder holder = await sendPaginated(request: _tipsProvider.fetchPaginated(query: query));
    return deserialize(holder: holder);
  }

  Future<List<EmployeeTip>> fetchByCustomerName({String? firstName, String? lastName, DateTimeRange? dateRange}) async {
    String firstNameQuery = (firstName == null || firstName.isEmpty) ? "" : "customerFirst=$firstName";
    String lastNameQuery = (lastName == null || lastName.isEmpty) ? "" : "&customerLast=$lastName";
    String fullNameQuery = firstNameQuery.isEmpty ? lastNameQuery.substring(1) : "$firstNameQuery$lastNameQuery";
    
    String query = formatQuery(baseQuery: "employees=single&$fullNameQuery", dateRange: dateRange);
    PaginateDataHolder holder = await sendPaginated(request: _tipsProvider.fetchPaginated(query: query));

    return holder.update(
      data: holder.data.map((tip) => EmployeeTip.fromJson(json: tip)).toList()
    ).data as List<EmployeeTip>;
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    PaginateDataHolder holder = await sendPaginated(request: _tipsProvider.fetchPaginated(paginateUrl: url));
    return deserialize(holder: holder);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((tip) => EmployeeTip.fromJson(json: tip)).toList()
    );
  }
}