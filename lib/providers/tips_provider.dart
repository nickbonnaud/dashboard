import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class TipsProvider extends BaseProvider {
  
  Future<PaginatedApiResponse> fetchPaginated({String? query, String? paginateUrl}) async {
    String url = paginateUrl ?? '${ApiEndpoints.tips}$query';
    return await getPaginated(url: url);
  }
}