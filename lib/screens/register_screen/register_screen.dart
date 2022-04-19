import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';

import 'widgets/register_card.dart';

class RegisterScreen extends StatelessWidget {
  
  const RegisterScreen({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: const Center(
        child: RegisterCard(),
      ),
    );
  }
}