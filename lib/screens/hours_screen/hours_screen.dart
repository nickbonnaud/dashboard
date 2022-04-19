import 'package:dashboard/screens/hours_screen/bloc/hours_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/hours_screen_body.dart';
class HoursScreen extends StatelessWidget {

  const HoursScreen({ Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Theme.of(context).colorScheme.secondary
      ),
      body: _hoursScreenBody(context: context),
    );
  }

  Widget _hoursScreenBody({required BuildContext context}) {
    return BlocProvider<HoursScreenBloc>(
      create: (_) => HoursScreenBloc(),
      child: const HoursScreenBody(),
    );
  }
}