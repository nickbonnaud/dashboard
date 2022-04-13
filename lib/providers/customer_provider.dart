import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class CustomerProvider extends BaseProvider {

  const CustomerProvider();
  
  Future<PaginatedApiResponse> fetchPaginated({String query = "", String? paginateUrl}) async {
    String url = paginateUrl ?? '${ApiEndpoints.customers}$query';
    return await getPaginated(url: url);
  }
}