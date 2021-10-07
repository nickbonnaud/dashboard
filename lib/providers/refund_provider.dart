import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class RefundProvider extends BaseProvider {

  Future<ApiResponse> fetch({required String query}) async {
    final String url = '${ApiEndpoints.refunds}$query';
    return await this.get(url: url);
  }

  Future<PaginatedApiResponse> fetchPaginated({String? query, String? paginateUrl}) async {
    final String url = paginateUrl == null ? '${ApiEndpoints.refunds}$query' : paginateUrl;
    return await this.getPaginated(url: url);
  }
}