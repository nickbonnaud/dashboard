import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class CredentialsProvider extends BaseProvider {

  const CredentialsProvider();
  
  Future<ApiResponse> fetch() async {
    String url = ApiEndpoints.credentials;
    return await get(url: url);
  }
}