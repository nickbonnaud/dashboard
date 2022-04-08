import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

class AccountMenuScreen extends StatelessWidget {
  
  const AccountMenuScreen({Key? key})
    : super(key: key);
  
  final List<String> accountRoutes = const [
    Routes.editProfile,
    Routes.editPhotos,
    Routes.editBusinessAccount,
    Routes.editOwners,
    Routes.editBank,
    Routes.editLocation,
    Routes.editHours,
    Routes.editPOS
  ];

  final List<String> routeTitles = const [
    "Profile",
    "Logos",
    "Business Details",
    "Owners",
    "Bank",
    "Location",
    "Operating Hours",
    "Point of Sale"
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _accountButtons(context: context)
        )
      ),
    );
  }

  List<Widget> _accountButtons({required BuildContext context}) {
    return List.generate(
      accountRoutes.length, 
      (index) => TextButton(
        onPressed: () => _buttonPressed(context: context, routeName: accountRoutes[index]), 
        child: Text3(text: routeTitles[index], context: context, color: Theme.of(context).colorScheme.callToAction)
      )
    );
  }

  void _buttonPressed({required BuildContext context, required String routeName}) {
    Navigator.of(context).pushNamed(routeName);
  }
}