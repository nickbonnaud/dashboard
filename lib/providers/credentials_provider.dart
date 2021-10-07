import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class CredentialsProvider extends BaseProvider {

  Future<ApiResponse> fetch() async {
    final String url = ApiEndpoints.credentials;
    return await this.get(url: url);
  }
}