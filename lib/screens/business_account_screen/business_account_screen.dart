import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/repositories/business_account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/business_account_screen_bloc.dart';
import 'widgets/business_account_screen_body.dart';

class BusinessAccountScreen extends StatelessWidget {
  final BusinessAccount _businessAccount;
  final BusinessAccountRepository _accountRepository;
  final BusinessBloc _businessBloc;
  
  const BusinessAccountScreen({
    required BusinessAccount businessAccount,
    required BusinessAccountRepository accountRepository,
    required BusinessBloc businessBloc
  })
    : _businessAccount = businessAccount,
      _accountRepository = accountRepository,
      _businessBloc = businessBloc;

  @override
  Widget build(BuildContext context) {

    return _businessAccount.identifier.isEmpty
      ? Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          ),
          body: _businessAccountScreenBody(),
        )
      : Scaffold(
          appBar: DefaultAppBar(context: context),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: _businessAccountScreenBody(),
      );
  }

  Widget _businessAccountScreenBody() {
    return BlocProvider<BusinessAccountScreenBloc>(
      create: (context) => BusinessAccountScreenBloc(
        accountRepository: _accountRepository,
        businessBloc: _businessBloc,
        businessAccount: _businessAccount
      ),
      child: BusinessAccountScreenBody(businessAccount: _businessAccount),
    );
  }
}