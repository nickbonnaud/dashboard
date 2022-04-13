import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class BusinessAccountProvider extends BaseProvider {

  const BusinessAccountProvider();
  
  Future<ApiResponse> store({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.payFacBusiness;
    return await post(url: url, body: body);
  }

  Future<ApiResponse> update({required Map<String, dynamic> body, required String identifier}) async {
    String url = "${ApiEndpoints.payFacBusiness}/$identifier";
    return await patch(url: url, body: body);
  }
}