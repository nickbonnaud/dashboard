import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/status.dart';
import 'package:dashboard/screens/onboard_screen/bloc/onboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/onboard_body.dart';

class OnboardScreen extends StatelessWidget {
  final Status _accountStatus;

  const OnboardScreen({required Status accountStatus})
    : _accountStatus = accountStatus;
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary
      ),
      body: BlocProvider<OnboardBloc>(
        create: (BuildContext context) => OnboardBloc(accountStatus: _accountStatus),
        child: OnboardBody(),
      ),
    );
  }
}