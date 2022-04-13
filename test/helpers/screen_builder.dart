import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/boot_phases/phase_one.dart';
import 'package:dashboard/models/business/accounts.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/models/business/location.dart';
import 'package:dashboard/models/business/photos.dart';
import 'package:dashboard/models/business/pos_account.dart';
import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/models/status.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MockRoute extends Mock implements Route {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class ScreenBuilder {
  final Widget child;
  final NavigatorObserver observer;

  final int? accountStatus;
  final Business? business;

  ScreenBuilder({
    required this.child,
    required this.observer,
    this.accountStatus,
    this.business
  });

  Future<void> createScreen({required WidgetTester tester, bool shouldPump = true}) async {
    await tester.pumpWidget(
      PhaseOne(
        testApp: MaterialApp(
          home: child,
          navigatorObservers: [observer],
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => Container(),
              settings: const RouteSettings(name: "test")
            );
          },
          builder: (context, widget) {
            _createBusiness(context: context);
            const SizeConfig().init(context);
            return ResponsiveWrapper.builder(
              ClampingScrollWrapper.builder(context, widget!),
              defaultScale: true,
              minWidth: 480,
              maxWidth: 1200,
              breakpoints: [
                const ResponsiveBreakpoint.resize(480, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
              ]
            );
          },
        )
      )
    );
    if (shouldPump) {
      await tester.pumpAndSettle();
    }
  }

  void _createBusiness({required BuildContext context}) {
    Business business = this.business ?? Business(
      identifier: 'identifier',
      email: 'email',
      profile: Profile.empty(),
      photos: Photos.empty(),
      accounts: Accounts(
        businessAccount: BusinessAccount.empty(),
        ownerAccounts: const [],
        bankAccount: BankAccount.empty(),
        accountStatus: Status(name: 'name', code: accountStatus ?? 100)
      ),
      location: Location.empty(),
      posAccount: PosAccount.empty()
    );

    BlocProvider.of<BusinessBloc>(context).add(BusinessLoggedIn(business: business));
  }
}
