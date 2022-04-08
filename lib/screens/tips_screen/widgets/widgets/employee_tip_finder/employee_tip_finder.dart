import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/employee_tip_finder_bloc.dart';
import 'widgets/name_field/bloc/name_field_bloc.dart';
import 'widgets/name_field/name_field.dart';
import 'widgets/tip_finder_list.dart';

class EmployeeTipFinder extends StatelessWidget {

  const EmployeeTipFinder({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Text4(text: "Search by Employee Name", context: context),
        _nameField(),
        SizedBox(height: SizeConfig.getHeight(3)),
        const TipFinderList()
      ],
    );
  }

  Widget _nameField() {
    return BlocProvider<NameFieldBloc>(
      create: (context) => NameFieldBloc(
        employeeTipFinderBloc: BlocProvider.of<EmployeeTipFinderBloc>(context)
      ),
      child: const NameField(),
    );
  }
}