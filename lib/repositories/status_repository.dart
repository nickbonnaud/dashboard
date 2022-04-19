import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/status.dart';
import 'package:dashboard/providers/status_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class StatusRepository extends BaseRepository {
  final StatusProvider? _statusProvider;

  const StatusRepository({StatusProvider? statusProvider})
    : _statusProvider = statusProvider;

  Future<List<Status>> fetchTransactionStatuses() async {
    StatusProvider statusProvider = _getStatusProvider();

    final PaginateDataHolder holder = await sendPaginated(request: statusProvider.fetchTransactionStatuses());
    return deserialize(holder: holder);
  }

  StatusProvider _getStatusProvider() {
    return _statusProvider ?? const StatusProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((status) => Status.fromJson(json: status)).toList()
    ).data;
  }
}