import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'widgets/bloc/login_form_bloc.dart';
import 'widgets/login_form.dart';


class LoginCard extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;

  const LoginCard({
    required AuthenticationRepository authenticationRepository,
    required AuthenticationBloc authenticationBloc,
    Key? key
  })
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        padding: const EdgeInsets.all(42),
        width: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width / 2.5,
        height: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.height / 1.5,
        child: BlocProvider<LoginFormBloc>(
          create: (BuildContext context) => LoginFormBloc(
            authenticationRepository: _authenticationRepository, 
            authenticationBloc: _authenticationBloc
          ),
          child: const LoginForm(),
        )
      ),
    );
  }
}