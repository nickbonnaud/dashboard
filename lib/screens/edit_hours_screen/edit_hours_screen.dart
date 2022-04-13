import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/edit_hours_screen_bloc.dart';
import 'widgets/edit_hours_screen_body.dart';

class EditHoursScreen extends StatelessWidget {
  final HoursRepository _hoursRepository;

  const EditHoursScreen({
    required HoursRepository hoursRepository,
    Key? key
  })
    : _hoursRepository = hoursRepository,
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
        businessBloc: BlocProvider.of<BusinessBloc>(context),
        hours: BlocProvider.of<BusinessBloc>(context).business.profile.hours
      ),
      child: EditHoursScreenBody(hours: BlocProvider.of<BusinessBloc>(context).business.profile.hours),
    );
  }
}