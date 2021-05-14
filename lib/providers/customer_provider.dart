import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';

class CustomerProvider extends BaseProvider {

  Future<PaginatedApiResponse> fetchPaginated({String query = "", String? paginateUrl}) async {
    final String url = paginateUrl == null
      ? 'customers$query'
      : paginateUrl;

    return await this.getPaginated(url: url);
  }
}