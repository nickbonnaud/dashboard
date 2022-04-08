import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class BusinessProvider extends BaseProvider {

  Future<ApiResponse> fetch() async {
    String url = ApiEndpoints.refreshSelf;
    return await get(url: url);
  }

  Future<ApiResponse> update({required Map<String, dynamic> body, required String identifier}) async {
    String url = "${ApiEndpoints.business}/$identifier";
    return await patch(url: url, body: body);
  }
}