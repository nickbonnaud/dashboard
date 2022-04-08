import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_endpoints.dart';

class MessageProvider extends BaseProvider {

  Future<ApiResponse> fetch() async {
    String url = "${ApiEndpoints.message}?unread=true";
    return await get(url: url);
  }
  
  Future<PaginatedApiResponse> fetchPaginated({String? query = "", String? paginateUrl}) async {
    String url = paginateUrl ?? "${ApiEndpoints.message}$query";
    return await getPaginated(url: url);
  }
  
  Future<ApiResponse> storeMessage({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.message;
    return await post(url: url, body: body);
  }
  
  Future<ApiResponse> storeReply({required Map<String, dynamic> body}) async {
    String url = ApiEndpoints.reply;
    return await post(url: url, body: body);
  }

  Future<ApiResponse> updateMessage({required Map<String, dynamic> body, required String messageIdentifier}) async {
    String url = '${ApiEndpoints.message}/$messageIdentifier';
    return await patch(url: url, body: body);
  }
}