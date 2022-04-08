import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/screens/hours_screen/bloc/hours_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/hours_screen_body.dart';

class HoursScreen extends StatelessWidget {
  final HoursRepository _hoursRepository;
  final BusinessBloc _businessBloc;
  final Hours _hours;

  const HoursScreen({
    required HoursRepository hoursRepository,
    required BusinessBloc businessBloc,
    required Hours hours,
    Key? key
  })
    : _hoursRepository = hoursRepository,
      _businessBloc = businessBloc,
      _hours = hours,
      super(key: key);

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
      child: HoursScreenBody(
        hoursRepository: _hoursRepository,
        businessBloc: _businessBloc,
        hours: _hours
      ),
    );
  }
}