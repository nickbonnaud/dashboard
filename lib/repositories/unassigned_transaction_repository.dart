import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/unassigned_transaction/unassigned_transaction.dart';
import 'package:dashboard/providers/unassigned_transaction_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:flutter/material.dart';

class UnassignedTransactionRepository extends BaseRepository {
  final UnassignedTransactionProvider? _unassignedTransactionProvider;

  const UnassignedTransactionRepository({UnassignedTransactionProvider? unassignedTransactionProvider})
    : _unassignedTransactionProvider = unassignedTransactionProvider;
  
  Future<PaginateDataHolder> fetchAll({DateTimeRange? dateRange}) async {
    final String query = formatDateQuery(dateRange: dateRange);

    UnassignedTransactionProvider unassignedTransactionProvider = _getUnassignedTransactionProvider();
    final PaginateDataHolder holder = await sendPaginated(request: unassignedTransactionProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    UnassignedTransactionProvider unassignedTransactionProvider = _getUnassignedTransactionProvider();

    final PaginateDataHolder holder = await sendPaginated(request: unassignedTransactionProvider.fetch(paginateUrl: url));
    return deserialize(holder: holder);
  }

  UnassignedTransactionProvider _getUnassignedTransactionProvider() {
    return _unassignedTransactionProvider ?? const UnassignedTransactionProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((unassigned) => UnassignedTransaction.fromJson(json: unassigned)).toList()
    );
  }
}