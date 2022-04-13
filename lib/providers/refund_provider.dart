import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class RefundProvider extends BaseProvider {

  const RefundProvider();
  
  Future<ApiResponse> fetch({required String query}) async {
    String url = '${ApiEndpoints.refunds}$query';
    return await get(url: url);
  }

  Future<PaginatedApiResponse> fetchPaginated({String? query, String? paginateUrl}) async {
    String url = paginateUrl ?? '${ApiEndpoints.refunds}$query';
    return await getPaginated(url: url);
  }
}