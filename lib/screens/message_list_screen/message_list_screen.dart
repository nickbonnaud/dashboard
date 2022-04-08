import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/global_widgets/app_bars/widgets/menu_button.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/message_list_screen_bloc.dart';
import 'widgets/message_list_screen_body.dart';

class MessageListScreen extends StatelessWidget {
  final MessageRepository _messageRepository;
  
  const MessageListScreen({required MessageRepository messageRepository, Key? key})
    : _messageRepository = messageRepository,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        context: context,
        trailingWidgets: const [MenuButton()],
      ),
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: BlocProvider<MessageListScreenBloc>(
        create: (_) => MessageListScreenBloc(
          messageRepository: _messageRepository
        )..add(Init()),
        child: MessageListScreenBody(
          messageRepository: _messageRepository,
        ),
      ),
    );
  }
}