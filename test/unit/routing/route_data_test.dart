import 'package:dashboard/routing/route_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Route Data Tests", () {

    test("RouteData [] operator returns value of query parameters if exists, else empty string", () {
      final Map<String, String> queryParams = { "query": "params" };
      
      RouteData routeData = RouteData(route: "fake", queryParameters: queryParams);
      expect(routeData['query'], queryParams["query"]);

      routeData = const RouteData(route: "fake");
      expect(routeData['query'], "");
    });

    test("RouteData factory can create RouteData", () {
      RouteSettings settings = const RouteSettings(name: "fake?query=params" );
      RouteData routeData = RouteData.init(settings: settings);
      expect(routeData.route, Uri.parse(settings.name!).path);
      expect(routeData['query'], Uri.parse(settings.name!).queryParameters['query']);
    });

    test("RouteData factory returns home route if settings name is null", () {
      RouteSettings settings = const RouteSettings();
      RouteData routeData = RouteData.init(settings: settings);
      expect(routeData.route, "/");
    });
  });
}