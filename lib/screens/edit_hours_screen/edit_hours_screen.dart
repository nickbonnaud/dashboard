import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/edit_hours_screen_bloc.dart';
import 'widgets/edit_hours_screen_body.dart';

class EditHoursScreen extends StatelessWidget {
  final HoursRepository _hoursRepository;
  final BusinessBloc _businessBloc;
  final Hours _hours;

  const EditHoursScreen({
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
      appBar: DefaultAppBar(context: context,),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _body(context: context),
    );
  }

  Widget _body({required BuildContext context}) {
    return BlocProvider<EditHoursScreenBloc>(
      create: (context) => EditHoursScreenBloc(
        hoursRepository: _hoursRepository,
        businessBloc: _businessBloc,
        hours: _hours
      ),
      child: EditHoursScreenBody(hours: _hours),
    );
  }
}