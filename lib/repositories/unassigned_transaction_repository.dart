import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/unassigned_transaction/unassigned_transaction.dart';
import 'package:dashboard/providers/unassigned_transaction_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:flutter/material.dart';

class UnassignedTransactionRepository extends BaseRepository {
  final UnassignedTransactionProvider _unassignedTransactionProvider;

  const UnassignedTransactionRepository({required UnassignedTransactionProvider unassignedTransactionProvider})
    : _unassignedTransactionProvider = unassignedTransactionProvider;
  
  Future<PaginateDataHolder> fetchAll({DateTimeRange? dateRange}) async {
    final String query = formatDateQuery(dateRange: dateRange);

    final PaginateDataHolder holder = await sendPaginated(request: _unassignedTransactionProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    final PaginateDataHolder holder = await sendPaginated(request: _unassignedTransactionProvider.fetch(paginateUrl: url));
    return deserialize(holder: holder);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((unassigned) => UnassignedTransaction.fromJson(json: unassigned)).toList()
    );
  }
}