import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/screens/hours_screen/bloc/hours_screen_bloc.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/bloc/hours_selection_form_bloc.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/model/hours_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/hours_confirmation_form_bloc.dart';
import 'widgets/hours_confirmation_form_body.dart';

class HoursConfirmationForm extends StatelessWidget {
  final HoursRepository _hoursRepository;
  final BusinessBloc _businessBloc;

  const HoursConfirmationForm({required HoursRepository hoursRepository, required BusinessBloc businessBloc})
    : _hoursRepository = hoursRepository,
      _businessBloc = businessBloc;
  
  @override
  Widget build(BuildContext context) {
    
    final HoursGrid hoursGrid = BlocProvider.of<HoursSelectionFormBloc>(context).state.operatingHoursGrid;
    return BlocProvider<HoursConfirmationFormBloc>(
      create: (context) => HoursConfirmationFormBloc(
        hoursRepository: _hoursRepository,
        businessBloc: _businessBloc,
        hoursGrid: hoursGrid,
        hoursList: hoursGrid.hoursList(earliestStart: BlocProvider.of<HoursScreenBloc>(context).state.earliestStart!)
      ),
      child: HoursConfirmationFormBody(),
    );
  }
}