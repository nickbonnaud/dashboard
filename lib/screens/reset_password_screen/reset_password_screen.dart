import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'bloc/reset_password_screen_bloc.dart';
import 'widget/reset_password_screen_body.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String? _token;

  const ResetPasswordScreen({
    @required String? token,
    Key? key
  })
    : _token = token,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: Center(
        child: Card(
          elevation: 2.0,
          child: Container(
            padding: const EdgeInsets.all(42),
            width: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2.5,
            height: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height / 1.5,
            child: BlocProvider<ResetPasswordScreenBloc>(
              create: (_) => ResetPasswordScreenBloc(
                authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
                token: _token
              ),
              child: ResetPasswordScreenBody(token: _token),
            ),
          ),
        ),
      ),
    );
  }
}