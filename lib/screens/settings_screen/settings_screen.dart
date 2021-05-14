import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/settings_screen_cubit.dart';
import 'widget/settings_screen_body.dart';

class SettingsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: DefaultAppBar(context: context),
      body: BlocProvider<SettingsScreenCubit>(
        create: (context) => SettingsScreenCubit(),
        child: SettingsScreenBody(),
      )
    );
  }
}