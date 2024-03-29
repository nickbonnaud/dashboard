import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/owners_screen_bloc.dart';
import 'widgets/owners_screen_body.dart';

class OwnersScreen extends StatelessWidget {

  const OwnersScreen({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _ownersScreenBody(context: context),
      appBar: BlocProvider.of<BusinessBloc>(context).business.accounts.ownerAccounts.isEmpty
        ? AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          )
        : DefaultAppBar(context: context)
    );
  }

  Widget _ownersScreenBody({required BuildContext context}) {
    return BlocProvider<OwnersScreenBloc>(
      create: (context) => OwnersScreenBloc(
        businessBloc: BlocProvider.of<BusinessBloc>(context),
        ownerRepository: RepositoryProvider.of<OwnerRepository>(context),
        ownerAccounts: BlocProvider.of<BusinessBloc>(context).business.accounts.ownerAccounts
      ),
      child: OwnersScreenBody(
        initialOwners: BlocProvider.of<BusinessBloc>(context).business.accounts.ownerAccounts
      ),
    );
  }
}