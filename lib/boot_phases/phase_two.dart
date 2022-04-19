import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'phase_three.dart';

class PhaseTwo extends StatelessWidget {
  final MaterialApp? _testApp;

  const PhaseTwo({MaterialApp? testApp, Key? key})
    : _testApp = testApp,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) => AuthenticationBloc(
        authenticationRepository: const AuthenticationRepository(), 
        businessBloc: BlocProvider.of<BusinessBloc>(context)
      )..add(Init()),
      child: PhaseThree(testApp: _testApp),
    );
  }
}