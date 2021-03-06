import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/providers/authentication_provider.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'phase_three.dart';

class PhaseTwo extends StatelessWidget {
  final MaterialApp? _testApp;
  final AuthenticationRepository _authenticationRepository = AuthenticationRepository(tokenRepository: TokenRepository(), authenticationProvider: AuthenticationProvider());

  PhaseTwo({MaterialApp? testApp})
    : _testApp = testApp;
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) => AuthenticationBloc(
        authenticationRepository: _authenticationRepository, 
        businessBloc: BlocProvider.of<BusinessBloc>(context)
      )..add(Init()),
      child: PhaseThree(testApp: _testApp),
    );
  }
}