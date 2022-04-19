import 'package:dashboard/global_widgets/app_bars/bottom_modal_app_bar.dart';
import 'package:dashboard/global_widgets/app_bars/widgets/menu_button.dart';
import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/screens/message_list_screen/bloc/message_list_screen_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/message_history_bloc.dart';
import 'widgets/message_screen_body.dart';

class MessageScreen extends StatelessWidget {
  final Message _message;

  const MessageScreen({required Message message, Key? key })
    : _message = message,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BottomModalAppBar(
        context: context,
        trailingWidgets: const [MenuButton()],
      ),
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: BlocProvider<MessageHistoryBloc>(
        create: (context) => MessageHistoryBloc(
          messageListScreenBloc: BlocProvider.of<MessageListScreenBloc>(context),
          message: _message
        )..add(MarkAsRead()),
        child: const MessageScreenBody()
      ),
    );
  }
}