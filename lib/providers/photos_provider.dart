import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class PhotosProvider extends BaseProvider {

  Future<ApiResponse> storeLogo({required String identifier, required Map<String, dynamic> body}) async {
    String url = "${ApiEndpoints.photos}/$identifier";
    return await post(url: url, body: body);
  }

  Future<ApiResponse> storeBanner({required String identifier, required Map<String, dynamic> body}) async {
    String url = "${ApiEndpoints.photos}/$identifier";
    return await post(url: url, body: body);
  }
}