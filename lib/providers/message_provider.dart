import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';

class MessageProvider extends BaseProvider {

  Future<ApiResponse> fetch() async {
    final String url = "message?unread=true";
    return await this.get(url: url);
  }
  
  Future<PaginatedApiResponse> fetchPaginated({String? query = "", String? paginateUrl}) async {
    final String url = paginateUrl == null ? "message$query" : paginateUrl;
    return await this.getPaginated(url: url);
  }
  
  Future<ApiResponse> storeMessage({required Map<String, dynamic> body}) async {
    final String url = 'message';
    return await this.post(url: url, body: body);
  }
  
  Future<ApiResponse> storeReply({required Map<String, dynamic> body}) async {
    final String url = 'reply';
    return await this.post(url: url, body: body);
  }

  Future<ApiResponse> updateMessage({required Map<String, dynamic> body, required String messageIdentifier}) async {
    final String url = 'message/$messageIdentifier';
    return await this.patch(url: url, body: body);
  }
}