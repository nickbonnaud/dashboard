import 'dart:io';
import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';

import 'mock_responses.dart';

class TestApiInterceptors extends InterceptorsWrapper {
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final Map<String, dynamic> json = MockResponses.mockResponse(options)!;
    
    if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
      Response response = _formatResponse(options: options, json: json);
      return handler.resolve(response);
    } else {
      Future.delayed(Duration(milliseconds: faker.randomGenerator.integer(3000, min: 100)))
        .then((_) {
           Response response = _formatResponse(options: options, json: json);
          return handler.resolve(response);
        }
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Response res = Response(
      requestOptions: response.requestOptions,
      data: response.data['data'] ?? response.data,
      extra: response.data['links']
    );
    return handler.resolve(res);
  }

  Response _formatResponse({required RequestOptions options,  required Map<String, dynamic> json}) {
    return Response(
      requestOptions: options, 
      data: json['data'] ?? json,
      extra: json['links']
    );
  }
}