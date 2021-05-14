import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';

class StatusProvider extends BaseProvider {

  Future<PaginatedApiResponse> fetchTransactionStatuses() async {
    final String url = 'status/transaction';
    return await this.getPaginated(url: url);
  }
}