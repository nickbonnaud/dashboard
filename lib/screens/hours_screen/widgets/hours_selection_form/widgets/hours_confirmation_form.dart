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

  const HoursConfirmationForm({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    final HoursGrid hoursGrid = BlocProvider.of<HoursSelectionFormBloc>(context).state.operatingHoursGrid;
    return BlocProvider<HoursConfirmationFormBloc>(
      create: (context) => HoursConfirmationFormBloc(
        hoursRepository: RepositoryProvider.of<HoursRepository>(context),
        businessBloc: BlocProvider.of<BusinessBloc>(context),
        hoursGrid: hoursGrid,
        hoursList: hoursGrid.hoursList(earliestStart: BlocProvider.of<HoursScreenBloc>(context).state.earliestStart!)
      ),
      child: const HoursConfirmationFormBody(),
    );
  }
}