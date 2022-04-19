import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/repositories/business_account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/business_account_screen_bloc.dart';
import 'widgets/business_account_screen_body.dart';

class BusinessAccountScreen extends StatelessWidget {
  
  const BusinessAccountScreen({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _businessAccountScreenBody(),
      appBar: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.identifier.isEmpty
        ? AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          )
        : DefaultAppBar(context: context)
    );
  }

  Widget _businessAccountScreenBody() {
    return BlocProvider<BusinessAccountScreenBloc>(
      create: (context) => BusinessAccountScreenBloc(
        accountRepository: RepositoryProvider.of<BusinessAccountRepository>(context),
        businessBloc: BlocProvider.of<BusinessBloc>(context),
        businessAccount: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount
      ),
      child: const BusinessAccountScreenBody(),
    );
  }
}