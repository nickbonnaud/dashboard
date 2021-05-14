import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';

class PhotosProvider extends BaseProvider {

  Future<ApiResponse> storeLogo({required String identifier, required Map<String, dynamic> body}) async {
    String url = "photos/$identifier";
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> storeBanner({required String identifier, required Map<String, dynamic> body}) async {
    String url = "photos/$identifier";
    return await this.post(url: url, body: body);
  }
}