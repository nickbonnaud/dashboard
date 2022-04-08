import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/screens/settings_screen/cubit/settings_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'widgets/locked_form/bloc/locked_form_bloc.dart';
import 'widgets/locked_form/locked_form.dart';
import 'widgets/unlocked_form/cubit/unlocked_form_cubit.dart';
import 'widgets/unlocked_form/unlocked_form.dart';

class SettingsScreenBody extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final BusinessRepository _businessRepository;
  final BusinessBloc _businessBloc;

  const SettingsScreenBody({
    required AuthenticationRepository authenticationRepository, 
    required BusinessRepository businessRepository,
    required BusinessBloc businessBloc,
    Key? key
  })
    : _authenticationRepository = authenticationRepository,
      _businessRepository = businessRepository,
      _businessBloc = businessBloc,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.only(
          left: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
            ? 0
            : SizeConfig.getWidth(10),
          right: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
            ? 0
            : SizeConfig.getWidth(10),
        ),
        child: BlocBuilder<SettingsScreenCubit, bool>(
          builder: (context, isLocked) {
            if (isLocked) {
              return _lockedForm(context: context);
            }
            return _unlockedForm();
          }
        ),
      )
    );
  }

  Widget _lockedForm({required BuildContext context}) {
    return BlocProvider<LockedFormBloc>(
      create: (context) => LockedFormBloc(
        authenticationRepository: _authenticationRepository,
        settingsScreenCubit: context.read<SettingsScreenCubit>()
      ),
      child: const LockedForm(),
    );
  }

  Widget _unlockedForm() {
    return BlocProvider<UnlockedFormCubit>(
      create: (_) => UnlockedFormCubit(),
      child: UnlockedForm(businessRepository: _businessRepository, businessBloc: _businessBloc),
    );
  }
}