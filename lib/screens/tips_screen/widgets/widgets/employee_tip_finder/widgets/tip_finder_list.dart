
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tip_finder/bloc/employee_tip_finder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import '../../tip_card.dart';

class TipFinderList extends StatelessWidget {

  const TipFinderList({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.getWidth(1),
        right: SizeConfig.getWidth(1)
      ),
      child: BlocBuilder<EmployeeTipFinderBloc, EmployeeTipFinderState>(
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty) return _error(context: context, error: state.errorMessage);
          if (state.tips.isEmpty) return _emptyList(context: context, state: state);

          return _tipsList(state: state);
        },
      )
    );
  }


  Widget _error({required BuildContext context, required String error}) {
    return Center(
      child: Column(
        children: [
          Text4(text: "Error: $error", context: context, color: Theme.of(context).colorScheme.error),
          Text4(text: "Please try again", context: context, color: Theme.of(context).colorScheme.error)
        ],
      ),
    );
  }

  Widget _emptyList({required BuildContext context, required EmployeeTipFinderState state}) {
    if (state.loading) return _loading(context: context);

    return state.currentFirstName.isNotEmpty || state.currentLastName.isNotEmpty
      ? _noTipsFound(context: context)
      : Container(key: const Key("emptyTipFinderListKey"));
  }

  Widget _loading({required BuildContext context}) {
    return Center(
      child: CircularProgressIndicator(color: Theme.of(context).colorScheme.callToAction),
    );
  }

  Widget _noTipsFound({required BuildContext context}) {
    return Center(
      child: BoldText5(text: "No Tips Found!", context: context),
    );
  }

  Widget _tipsList({required EmployeeTipFinderState state}) {
    return ListView.builder(
      key: const Key("employeeTipsListKey"),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => TipCard(employeeTip: state.tips[index]),
      itemCount: state.tips.length, 
    );
  }
}