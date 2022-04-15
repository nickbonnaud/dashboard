import 'package:dashboard/screens/login_screen/widgets/login_card.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: const Center(
        child: LoginCard(),
      ),
    );
  }
}