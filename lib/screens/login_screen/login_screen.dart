import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/screens/login_screen/widgets/login_card.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

class LoginScreen extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;

  const LoginScreen({
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
        child: LoginCard(
          authenticationRepository: _authenticationRepository,
          authenticationBloc: _authenticationBloc,
        ),
      ),
    );
  }
}