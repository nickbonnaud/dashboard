import 'package:dashboard/repositories/customer_repository.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/repositories/unassigned_transaction_repository.dart';
import 'package:dashboard/routing/routes.dart';
import 'package:dashboard/screens/home_screen/home_screen.dart';
import 'package:dashboard/screens/login_screen/login_screen.dart';
import 'package:dashboard/screens/onboard_screen/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/business/business_bloc.dart';
import 'repositories/authentication_repository.dart';

class App extends StatelessWidget {

  const App({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previousState, currentState) {
        return previousState is Authenticated && currentState is Unauthenticated;
      },
      listener: (context, state) {
        Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previousState, currentState) => previousState is Unknown,
        builder: (context, state) {
          return _setInitialScreen(context: context, state: state);
        },
      ),
    );
  }

  Widget _setInitialScreen({required BuildContext context, required AuthenticationState state}) {
    if (state is Unknown) return Container();

    if (state is Authenticated) {
      return _buildAuthenticatedScreen();
    } else {
      return RepositoryProvider(
        create: (context) => const AuthenticationRepository(),
        child: const LoginScreen(),
      );
    }
  }

  Widget _buildAuthenticatedScreen() {
    return BlocBuilder<BusinessBloc, BusinessState>(
      buildWhen: (previousState, currentState) {
        return previousState is BusinessLoading && currentState is BusinessLoaded;
      },
      builder: (context, state) {
        if (state is BusinessLoaded) {
          return state.business.accounts.accountStatus.code < 120
            ? const OnboardScreen()
            : _homeScreen();
        }
        return Container();
      }
    );
  }

  Widget _homeScreen() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => const TransactionRepository()
        ),

        RepositoryProvider(
          create: (_) => const RefundRepository(),
        ),

        RepositoryProvider(
          create: (_) => const TipsRepository(),
        ),

        RepositoryProvider(
          create: (_) => const UnassignedTransactionRepository(),
        ),

        RepositoryProvider(
          create: (_) => const CustomerRepository(),
        ),
      ],
      child: const HomeScreen()
    );
  }
}