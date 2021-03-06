import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';

class AuthenticationProvider extends BaseProvider {

  Future<ApiResponse> register({required Map<String, dynamic> body}) async {
    final String url = 'auth/register';
    return await this.post(url: url, body: body);
  }
  
  Future<ApiResponse> login({required Map<String, dynamic> body}) async {
    final String url = "auth/login";
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> logout() async {
    final String url = "auth/logout";
    return await this.get(url: url);
  }

  Future<ApiResponse> verifyPassword({required Map<String, dynamic> body}) async {
    final String url = 'auth/verify';
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> requestPasswordReset({required Map<String, dynamic> body}) async {
    final String url = 'auth/request-reset';
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> resetPassword({required Map<String, dynamic> body}) async {
    final String url = 'auth/reset-password';
    return this.patch(url: url, body: body);
  }
}