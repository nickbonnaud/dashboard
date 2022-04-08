import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'widgets/register_card.dart';

class RegisterScreen extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;
  
  const RegisterScreen({
    required AuthenticationRepository authenticationRepository, 
    required AuthenticationBloc authenticationBloc,
    Key? key
  })
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: Center(
        child: RegisterCard(
          authenticationRepository: _authenticationRepository,
          authenticationBloc: _authenticationBloc,
        ),
      ),
    );
  }
}