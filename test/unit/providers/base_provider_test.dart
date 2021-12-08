
import 'package:dashboard/models/api_response.dart';
import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/providers/base_provider.dart';
import 'package:dashboard/resources/http/api_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group("Base Provider Tests", () {
    const String path = 'http://novapay.ai/api/business';
    
    late Dio dio;
    late DioAdapter dioAdapter;
    late BaseProvider baseProvider;

    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
    });

    test("Successful get request returns ApiResponse", () async {
      dioAdapter..onGet("$path/", (request) => request.reply(200, {'data': {"type": 'get', 'success': true}}));
      dio.httpClientAdapter = dioAdapter;
      dio.interceptors.add(ApiInterceptors());
      baseProvider = BaseProvider(dio: dio);
      
      var response = await baseProvider.get(url: "");
      expect(response, isA<ApiResponse>());
      expect(response.isOK, true);
      expect(response.error.isEmpty, true);
    });

    test("Unsuccessful get request returns ApiResponse with error", () async {
      final dioError = DioError(
        error: {"message": "error message"},
        requestOptions: RequestOptions(path: "/"),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: "/")
        ),
        type: DioErrorType.response
      );
      
      dioAdapter..onGet("$path/", (request) => request.throws(400, dioError));
      dio.httpClientAdapter = dioAdapter;
      dio.interceptors.add(ApiInterceptors());
      baseProvider = BaseProvider(dio: dio);
      
      var response = await baseProvider.get(url: "");
      expect(response, isA<ApiResponse>());
      expect(response.isOK, false);
      expect(response.error.isNotEmpty, true);
    });

    test("Successful getPaginated request returns PaginatedApiResponse", () async {
      dioAdapter..onGet("$path/", (request) => request.reply(200, {'data': [{"type": 'get', 'success': true}], "links": {'next': "next-url"}}));
      dio.httpClientAdapter = dioAdapter;
      dio.interceptors.add(ApiInterceptors());
      baseProvider = BaseProvider(dio: dio);
      
      var response = await baseProvider.getPaginated(url: "");
      expect(response, isA<PaginatedApiResponse>());
      expect(response.isOK, true);
      expect(response.error.isEmpty, true);
    });

    test("Unsuccessful getPaginated request returns PaginatedApiResponse with error", () async {
      final dioError = DioError(
        error: {"message": "error message"},
        requestOptions: RequestOptions(path: "/"),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: "/")
        ),
        type: DioErrorType.response
      );
      
      dioAdapter..onGet("$path/", (request) => request.throws(400, dioError));
      
      dio.httpClientAdapter = dioAdapter;
      dio.interceptors.add(ApiInterceptors());
      baseProvider = BaseProvider(dio: dio);
      
      var response = await baseProvider.getPaginated(url: "");
      expect(response, isA<PaginatedApiResponse>());
      expect(response.isOK, false);
      expect(response.error.isNotEmpty, true);
    });

    test("Successful post request returns ApiResponse", () async {
      dioAdapter..onPost(
        "$path/", 
        (request) => request.reply(200, {'data': {"type": 'get', 'success': true}}),
        data: {}
      );
      dio.httpClientAdapter = dioAdapter;
      dio.interceptors.add(ApiInterceptors());
      baseProvider = BaseProvider(dio: dio);
      
      var response = await baseProvider.post(url: "", body: {});
      expect(response, isA<ApiResponse>());
      expect(response.isOK, true);
      expect(response.error.isEmpty, true);
    });

    test("Unsuccessful post request returns ApiResponse", () async {
      final dioError = DioError(
        error: {"message": "error message"},
        requestOptions: RequestOptions(path: "/"),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: "/")
        ),
        type: DioErrorType.response
      );
      
      dioAdapter..onPost(
        "$path/", 
        (request) => request.throws(400, dioError),
        data: {}
      );
      dio.httpClientAdapter = dioAdapter;
      dio.interceptors.add(ApiInterceptors());
      baseProvider = BaseProvider(dio: dio);
      
      var response = await baseProvider.post(url: "", body: {});
      expect(response, isA<ApiResponse>());
      expect(response.isOK, false);
      expect(response.error.isNotEmpty, true);
    });

    test("Successful patch request returns ApiResponse", () async {
      dioAdapter..onPatch(
        "$path/", 
        (request) => request.reply(200, {'data': {"type": 'get', 'success': true}}),
        data: {}
      );
      dio.httpClientAdapter = dioAdapter;
      dio.interceptors.add(ApiInterceptors());
      baseProvider = BaseProvider(dio: dio);
      
      var response = await baseProvider.patch(url: "", body: {});
      expect(response, isA<ApiResponse>());
      expect(response.isOK, true);
      expect(response.error.isEmpty, true);
    });

    test("Unsuccessful patch request returns ApiResponse", () async {
      final dioError = DioError(
        error: {"message": "error message"},
        requestOptions: RequestOptions(path: "/"),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: "/")
        ),
        type: DioErrorType.response
      );
      
      dioAdapter..onPatch(
        "$path/", 
        (request) => request.throws(400, dioError),
        data: {}
      );
      dio.httpClientAdapter = dioAdapter;
      dio.interceptors.add(ApiInterceptors());
      baseProvider = BaseProvider(dio: dio);
      
      var response = await baseProvider.patch(url: "", body: {});
      expect(response, isA<ApiResponse>());
      expect(response.isOK, false);
      expect(response.error.isNotEmpty, true);
    });

    test("Successful delete request returns ApiResponse", () async {
      dioAdapter..onDelete(
        "$path/", 
        (request) => request.reply(200, {'data': {"type": 'get', 'success': true}}),
      );
      dio.httpClientAdapter = dioAdapter;
      dio.interceptors.add(ApiInterceptors());
      baseProvider = BaseProvider(dio: dio);
      
      var response = await baseProvider.delete(url: "");
      expect(response, isA<ApiResponse>());
      expect(response.isOK, true);
      expect(response.error.isEmpty, true);
    });

    test("Unsuccessful delete request returns ApiResponse", () async {
      final dioError = DioError(
        error: {"message": "error message"},
        requestOptions: RequestOptions(path: "/"),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: "/")
        ),
        type: DioErrorType.response
      );
      
      dioAdapter..onDelete(
        "$path/", 
        (request) => request.throws(400, dioError),
      );
      dio.httpClientAdapter = dioAdapter;
      dio.interceptors.add(ApiInterceptors());
      baseProvider = BaseProvider(dio: dio);
      
      var response = await baseProvider.delete(url: "");
      expect(response, isA<ApiResponse>());
      expect(response.isOK, false);
      expect(response.error.isNotEmpty, true);
    });
  });
}