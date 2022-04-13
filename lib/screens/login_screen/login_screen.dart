import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/screens/login_screen/widgets/login_card.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  const LoginScreen({
    required AuthenticationRepository authenticationRepository,
    Key? key
  })
    : _authenticationRepository = authenticationRepository,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: Center(
        child: LoginCard(
          authenticationRepository: _authenticationRepository,
        ),
      ),
    );
  }
}