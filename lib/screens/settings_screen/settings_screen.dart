import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'cubit/settings_screen_cubit.dart';
import 'widget/settings_screen_body.dart';

class SettingsScreen extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final BusinessRepository _businessRepository;
  final BusinessBloc _businessBloc;

  const SettingsScreen({
    required AuthenticationRepository authenticationRepository,
    required BusinessRepository businessRepository,
    required BusinessBloc businessBloc
  })
    : _authenticationRepository = authenticationRepository,
      _businessRepository = businessRepository,
      _businessBloc = businessBloc;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      appBar: DefaultAppBar(context: context),
      body: BlocProvider<SettingsScreenCubit>(
        create: (context) => SettingsScreenCubit(),
        child: SettingsScreenBody(
          authenticationRepository: _authenticationRepository,
          businessRepository: _businessRepository,
          businessBloc: _businessBloc,
        ),
      )
    );
  }
}