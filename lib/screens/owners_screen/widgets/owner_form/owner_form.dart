import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/screens/owners_screen/bloc/owners_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/owner_form_bloc.dart';
import 'widgets/owner_form_body.dart';


class OwnerForm extends StatelessWidget {
  final OwnerRepository _ownerRepository;
  final OwnerAccount? _ownerAccount;

  const OwnerForm({required OwnerRepository ownerRepository, OwnerAccount? ownerAccount})
    : _ownerRepository = ownerRepository,
      _ownerAccount = ownerAccount;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OwnerFormBloc>(
      create: (context) => OwnerFormBloc(
        ownerRepository: _ownerRepository,
        ownersScreenBloc: BlocProvider.of<OwnersScreenBloc>(context)
      ),
      child: OwnerFormBody(ownerAccount: _ownerAccount),
    );
  }
}