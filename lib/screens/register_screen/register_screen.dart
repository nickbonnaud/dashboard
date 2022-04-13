import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';

import 'widgets/register_card.dart';

class RegisterScreen extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  
  const RegisterScreen({
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
        child: RegisterCard(
          authenticationRepository: _authenticationRepository
        ),
      ),
    );
  }
}