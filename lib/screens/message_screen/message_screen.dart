import 'package:dashboard/global_widgets/app_bars/bottom_modal_app_bar.dart';
import 'package:dashboard/global_widgets/app_bars/widgets/menu_button.dart';
import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/screens/message_list_screen/bloc/message_list_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/message_history_bloc.dart';
import 'widgets/message_screen_body.dart';

class MessageScreen extends StatelessWidget {
  final Message _message;
  final MessageListScreenBloc _messageListScreenBloc;
  final MessageRepository _messageRepository;

  const MessageScreen({
    required Message message,
    required MessageListScreenBloc messageListScreenBloc,
    required MessageRepository messageRepository
  })
    : _message = message,
      _messageListScreenBloc = messageListScreenBloc,
      _messageRepository = messageRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BottomModalAppBar(
        context: context,
        trailingWidgets: [MenuButton()],
      ),
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: BlocProvider<MessageHistoryBloc>(
        create: (_) => MessageHistoryBloc(
          messageListScreenBloc: _messageListScreenBloc,
          message: _message
        )..add(MarkAsRead()),
        child: MessageScreenBody(messageRepository: _messageRepository,)
      ),
    );
  }
}