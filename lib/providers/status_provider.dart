import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class StatusProvider extends BaseProvider {

  Future<PaginatedApiResponse> fetchTransactionStatuses() async {
    String url = ApiEndpoints.transactionStatuses;
    return await getPaginated(url: url);
  }
}