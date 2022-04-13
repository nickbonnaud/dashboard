import 'package:dashboard/models/hour.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/hours_screen/bloc/hours_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'hours_selection_form/bloc/hours_selection_form_bloc.dart';
import 'hours_selection_form/hours_selection_form.dart';
import 'max_hours_form.dart';

class HoursScreenBody extends StatelessWidget{
  final HoursRepository _hoursRepository;

  const HoursScreenBody({
    required HoursRepository hoursRepository,
    Key? key
  })
    : _hoursRepository = hoursRepository,
      super(key: key);
      
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.getWidth(1),
        right: SizeConfig.getWidth(1)
      ),
      child: SingleChildScrollView(
        key: const Key("scrollKey"),
        child: Column(
          children: [
            _title(context: context),
            SizedBox(height: SizeConfig.getHeight(5)),
            _body(context: context)
          ],
        ),
      ),
    );
  }

  Widget _title({required BuildContext context}) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.getHeight(3)),
          BoldText3(text: 'Operating Hours', context: context)
        ],
      ),
    );
  }

  Widget _body({required BuildContext context}) {
    return BlocBuilder<HoursScreenBloc, HoursScreenState>(
      builder: (context, state) {
        if (state.earliestStart == null || state.latestEnd == null) return const MaxHoursForm();
        
        return BlocProvider<HoursSelectionFormBloc>(
          create: (_) => HoursSelectionFormBloc(operatingHoursRange: Hour(start: state.earliestStart!, end: state.latestEnd!)),
          child: HoursSelectionForm(
            hoursRepository: _hoursRepository,
          ),
        );
      }
    );
  }
}