import 'package:dashboard/providers/authentication_provider.dart';
import 'package:dashboard/providers/customer_provider.dart';
import 'package:dashboard/providers/refund_provider.dart';
import 'package:dashboard/providers/tips_provider.dart';
import 'package:dashboard/providers/transaction_provider.dart';
import 'package:dashboard/providers/unassigned_transaction_provider.dart';
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
import 'repositories/token_repository.dart';

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
      return const LoginScreen(
        authenticationRepository: AuthenticationRepository(tokenRepository: TokenRepository(), authenticationProvider: AuthenticationProvider()),
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
            : const HomeScreen(
              transactionRepository: TransactionRepository(transactionProvider: TransactionProvider()),
              refundRepository: RefundRepository(refundProvider: RefundProvider()),
              tipsRepository: TipsRepository(tipsProvider: TipsProvider()),
              unassignedTransactionRepository: UnassignedTransactionRepository(unassignedTransactionProvider: UnassignedTransactionProvider()),
              customerRepository: CustomerRepository(customerProvider: CustomerProvider()),
            );
        }
        return Container();
      }
    );
  }
}