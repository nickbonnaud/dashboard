import 'package:dashboard/resources/constants.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/routing/routes.dart';
import 'package:dashboard/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'routing/app_router.dart';


class Boot extends StatelessWidget {
  final MaterialApp? _testApp;
  final AppRouter _router = AppRouter();

  Boot({MaterialApp? testApp})
    : _testApp = testApp;
  
  @override
  Widget build(BuildContext context) {
    return _testApp == null
      ? _app(context: context)
      : _testApp!;
  }

  MaterialApp _app({required BuildContext context}) {
    return MaterialApp(
      initialRoute: Routes.app,
      theme: MainTheme.themeData(context: context),
      title: '${Constants.appName} Dashboard',
      onGenerateRoute: (settings) => _router.goTo(context: context, settings: settings),
      builder: (context, widget) {
        SizeConfig().init(context);
        return ResponsiveWrapper.builder(
          ClampingScrollWrapper.builder(context, widget!),
          defaultScale: true,
          minWidth: 480,
          maxWidth: 1200,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ]
        );
      },
    );
  }
}