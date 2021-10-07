import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class BusinessProvider extends BaseProvider {

  Future<ApiResponse> fetch() async {
    final String url = ApiEndpoints.refreshSelf;
    return await this.get(url: url);
  }

  Future<ApiResponse> update({required Map<String, dynamic> body, required String identifier}) async {
    final String url = "${ApiEndpoints.business}/$identifier";
    return await this.patch(url: url, body: body);
  }
}