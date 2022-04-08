import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class AuthenticationProvider extends BaseProvider {

  Future<ApiResponse> register({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.register;
    return await post(url: url, body: body);
  }
  
  Future<ApiResponse> login({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.login;
    return await post(url: url, body: body);
  }

  Future<ApiResponse> logout() async {
    String url = ApiEndpoints.logout;
    return await get(url: url);
  }

  Future<ApiResponse> verifyPassword({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.verifyPassword;
    return await post(url: url, body: body);
  }

  Future<ApiResponse> requestPasswordReset({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.requestPasswordReset;
    return await post(url: url, body: body);
  }

  Future<ApiResponse> resetPassword({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.resetPassword;
    return patch(url: url, body: body);
  }
}