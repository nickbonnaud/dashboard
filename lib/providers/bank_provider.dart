import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class BankProvider extends BaseProvider {

  Future<ApiResponse> store({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.payFacBank;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> update({required Map<String, dynamic> body, required String identifier}) async {
    final String url = "${ApiEndpoints.payFacBank}/$identifier";
    return await this.patch(url: url, body: body);
  }
}