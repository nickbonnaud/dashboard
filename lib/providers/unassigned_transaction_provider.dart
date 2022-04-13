import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class UnassignedTransactionProvider extends BaseProvider {

  const UnassignedTransactionProvider();
  
  Future<PaginatedApiResponse> fetch({String? query, String? paginateUrl}) async {
    String url = paginateUrl ?? '${ApiEndpoints.unassignedTransactions}$query';
    return await getPaginated(url: url);
  }
}