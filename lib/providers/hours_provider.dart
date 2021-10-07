import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class HoursProvider extends BaseProvider {

  Future<ApiResponse> store({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.hours;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> update({required Map<String, dynamic> body, required String identifier}) async {
    final String url = "${ApiEndpoints.hours}/$identifier";
    return await this.patch(url: url, body: body);
  }
}