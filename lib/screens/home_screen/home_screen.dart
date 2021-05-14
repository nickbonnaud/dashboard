import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/home_screen_cubit.dart';
import 'widgets/home_screen_body.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeScreenCubit>(
      create: (_) => HomeScreenCubit(),
      child: HomeScreenBody(),
    );
  }
}