import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/owners_screen_bloc.dart';
import 'widgets/owners_screen_body.dart';

class OwnersScreen extends StatelessWidget {
  final OwnerRepository _ownerRepository;
  final BusinessBloc _businessBloc;
  final List<OwnerAccount> _ownerAccounts;

  const OwnersScreen({
    required OwnerRepository ownerRepository,
    required BusinessBloc businessBloc,
    required List<OwnerAccount> ownerAccounts
  })
    : _ownerRepository = ownerRepository,
      _businessBloc = businessBloc,
      _ownerAccounts = ownerAccounts;

  @override
  Widget build(BuildContext context) {
    return _ownerAccounts.length == 0
      ? Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          ),
          body: _ownersScreenBody(context: context),
        )
      : Scaffold(
        appBar: DefaultAppBar(context: context),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: _ownersScreenBody(context: context),
      );
  }

  Widget _ownersScreenBody({required BuildContext context}) {
    return BlocProvider<OwnersScreenBloc>(
      create: (context) => OwnersScreenBloc(
        businessBloc: _businessBloc,
        ownerRepository: _ownerRepository,
        ownerAccounts: _ownerAccounts
      ),
      child: OwnersScreenBody(
        ownerRepository: _ownerRepository,
        initialOwners: _ownerAccounts
      ),
    );
  }
}