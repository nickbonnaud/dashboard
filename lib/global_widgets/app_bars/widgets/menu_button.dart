import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/routing/routes.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MenuButton extends StatelessWidget {
  
  final List<String> options = [
    "Account Settings",
    "Sign Out"
  ];
  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Menu',
      initialValue: "Settings",
      child: Padding(
        padding: EdgeInsets.only(right: SizeConfig.getWidth(2)),
        child: Row(
          children: [
            Text4(
              text: "Settings",
              context: context,
              color: Theme.of(context).colorScheme.callToAction
            ),
            Icon(
              Icons.arrow_drop_down,
              size: FontSizeAdapter.setSize(size: 3.5, context: context),
            )
          ],
        ),
      ),
      onSelected: (selection) => _selectionChanged(context: context, selection: selection),
      itemBuilder: (context) => options.map((option) {
        return PopupMenuItem(
          value: option,
          child: Text4(
            text: option,
            context: context,
            color: Theme.of(context).colorScheme.callToAction,
          )
        );
      }).toList()
    );
  }

  void _selectionChanged({required BuildContext context, required String selection}) {
    selection == 'Account Settings'
      ? _goToSettings(context: context)
      : _signout(context: context);
  }

  void _goToSettings({required BuildContext context}) {
    Navigator.of(context).pushNamed(Routes.settings);
  }

  void _signout({required BuildContext context}) {
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }
}