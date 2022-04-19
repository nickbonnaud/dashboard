import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/screens/owners_screen/bloc/owners_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/owner_form_bloc.dart';
import 'widgets/owner_form_body.dart';


class OwnerForm extends StatelessWidget {
  final OwnerAccount? _ownerAccount;

  const OwnerForm({OwnerAccount? ownerAccount, Key? key})
    : _ownerAccount = ownerAccount,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OwnerFormBloc>(
      create: (context) => OwnerFormBloc(
        ownerRepository: RepositoryProvider.of<OwnerRepository>(context),
        ownersScreenBloc: BlocProvider.of<OwnersScreenBloc>(context),
        ownerAccount: _ownerAccount
      ),
      child: OwnerFormBody(ownerAccount: _ownerAccount),
    );
  }
}