import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/repositories/bank_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bank_screen_bloc.dart';
import 'widgets/bank_screen_body.dart';

class BankScreen extends StatelessWidget {
  final BankRepository _bankRepository;

  const BankScreen({
    required BankRepository bankRepository,
    Key? key
  })
    : _bankRepository = bankRepository,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: BlocProvider.of<BusinessBloc>(context).business.accounts.bankAccount.identifier.isEmpty
        ? AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          )
        : DefaultAppBar(context: context),
      body: _bankScreenBody(),
    );
  }

  Widget _bankScreenBody() {
    return BlocProvider<BankScreenBloc>(
      create: (context) => BankScreenBloc(
        bankRepository: _bankRepository,
        businessBloc: BlocProvider.of<BusinessBloc>(context),
      ),
      child: const BankScreenBody(),
    );
  }
}