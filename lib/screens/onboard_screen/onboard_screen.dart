import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/screens/onboard_screen/bloc/onboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/onboard_body.dart';

class OnboardScreen extends StatelessWidget {

  const OnboardScreen({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary
      ),
      body: BlocProvider<OnboardBloc>(
        create: (BuildContext context) => OnboardBloc(
          accountStatus: BlocProvider.of<BusinessBloc>(context).business.accounts.accountStatus
        ),
        child: const OnboardBody(),
      ),
    );
  }
}