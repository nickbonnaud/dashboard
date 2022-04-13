import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/repositories/business_account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/business_account_screen_bloc.dart';
import 'widgets/business_account_screen_body.dart';

class BusinessAccountScreen extends StatelessWidget {
  final BusinessAccountRepository _accountRepository;
  
  const BusinessAccountScreen({
    required BusinessAccountRepository accountRepository,
    Key? key
  })
    : _accountRepository = accountRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.identifier.isEmpty
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
        businessBloc: BlocProvider.of<BusinessBloc>(context),
        businessAccount: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount
      ),
      child: const BusinessAccountScreenBody(),
    );
  }
}