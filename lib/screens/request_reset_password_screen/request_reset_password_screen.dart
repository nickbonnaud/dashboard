import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'bloc/request_reset_password_screen_bloc.dart';
import 'widgets/request_reset_password_screen_body.dart';

class RequestResetPasswordScreen extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  const RequestResetPasswordScreen({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      appBar: _appBar(context: context),
      body: Center(
        child: Card(
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.all(42),
            width: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2.5,
            height: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height / 1.5,
            child: BlocProvider<RequestResetPasswordScreenBloc>(
              create: (_) => RequestResetPasswordScreenBloc(
                authenticationRepository: _authenticationRepository
              ),
              child: RequestResetPasswordScreenBody(),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar({required BuildContext context}) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close),
        iconSize: FontSizeAdapter.setSize(size: 4, context: context), 
        color: Theme.of(context).colorScheme.callToAction,
        onPressed: () => Navigator.of(context).pop()
      ),
    );
  }
}