import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'widgets/bloc/login_form_bloc.dart';
import 'widgets/login_form.dart';


class LoginCard extends StatelessWidget {

  const LoginCard({ Key? key})
    : super(key: key);

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
            authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context), 
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)
          ),
          child: const LoginForm(),
        )
      ),
    );
  }
}