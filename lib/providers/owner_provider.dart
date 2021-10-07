import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class OwnerProvider extends BaseProvider {

  Future<ApiResponse> store({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.payFacOwner;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> update({required String identifier, required Map<String, dynamic> body}) async {
    final String url = '${ApiEndpoints.payFacOwner}/$identifier';
    return await this.patch(url: url, body: body);
  }

  Future<ApiResponse> remove({required String identifier}) async {
    final String url = '${ApiEndpoints.payFacOwner}/$identifier';
    return await this.delete(url: url);
  }
}