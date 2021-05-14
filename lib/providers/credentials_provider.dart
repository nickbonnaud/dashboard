import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';

class CredentialsProvider extends BaseProvider {

  Future<ApiResponse> fetch() async {
    final String url = 'credentials';
    return await this.get(url: url);
  }
}