import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class UnassignedTransactionProvider extends BaseProvider {

  Future<PaginatedApiResponse> fetch({String? query, String? paginateUrl}) async {
    final String url = paginateUrl == null
      ? '${ApiEndpoints.unassignedTransactions}$query' 
      : paginateUrl;
    return await this.getPaginated(url: url);
  }
}