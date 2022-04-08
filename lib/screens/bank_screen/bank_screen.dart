import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/repositories/bank_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bank_screen_bloc.dart';
import 'widgets/bank_screen_body.dart';

class BankScreen extends StatelessWidget {
  final BankAccount _bankAccount;
  final BankRepository _bankRepository;
  final BusinessBloc _businessBloc;

  const BankScreen({
    required BankAccount bankAccount,
    required BankRepository bankRepository,
    required BusinessBloc businessBloc,
    Key? key
  })
    : _bankAccount = bankAccount,
      _bankRepository = bankRepository,
      _businessBloc = businessBloc,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return _bankAccount.identifier.isEmpty
      ? Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          ),
          body: _bankScreenBody(),
        )
      : Scaffold(
          appBar: DefaultAppBar(context: context),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: _bankScreenBody(),
        );
  }

  Widget _bankScreenBody() {
    return BlocProvider<BankScreenBloc>(
      create: (context) => BankScreenBloc(
        bankRepository: _bankRepository,
        businessBloc: _businessBloc,
        bankAccount: _bankAccount
      ),
      child: BankScreenBody(bankAccount: _bankAccount),
    );
  }
}