import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/blocs/credentials/credentials_bloc.dart';
import 'package:dashboard/blocs/messages/messages_bloc.dart';
import 'package:dashboard/providers/credentials_provider.dart';
import 'package:dashboard/providers/message_provider.dart';
import 'package:dashboard/repositories/credentials_repository.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../boot.dart';

class PhaseThree extends StatelessWidget {
  final MaterialApp? _testApp;
  final CredentialsRepository _credentialsRepository = CredentialsRepository(credentialsProvider: CredentialsProvider());
  final MessageRepository _messageRepository = MessageRepository(messageProvider: MessageProvider());
  
  PhaseThree({MaterialApp? testApp, Key? key})
    : _testApp = testApp,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CredentialsBloc>(
          create: (BuildContext context) => CredentialsBloc(
            credentialsRepository: _credentialsRepository,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)
          ),
        ),

        BlocProvider<MessagesBloc>(
          create: (context) => MessagesBloc(
            messageRepository: _messageRepository,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)
          )
        )
      ],
      child: Boot(testApp: _testApp)
    );
  }
}