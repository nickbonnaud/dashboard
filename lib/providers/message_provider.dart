import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class MessageProvider extends BaseProvider {

  Future<ApiResponse> fetch() async {
    final String url = "${ApiEndpoints.message}?unread=true";
    return await this.get(url: url);
  }
  
  Future<PaginatedApiResponse> fetchPaginated({String? query = "", String? paginateUrl}) async {
    final String url = paginateUrl == null ? "${ApiEndpoints.message}$query" : paginateUrl;
    return await this.getPaginated(url: url);
  }
  
  Future<ApiResponse> storeMessage({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.message;
    return await this.post(url: url, body: body);
  }
  
  Future<ApiResponse> storeReply({required Map<String, dynamic> body}) async {
    final String url = ApiEndpoints.reply;
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> updateMessage({required Map<String, dynamic> body, required String messageIdentifier}) async {
    final String url = '${ApiEndpoints.message}/$messageIdentifier';
    return await this.patch(url: url, body: body);
  }
}