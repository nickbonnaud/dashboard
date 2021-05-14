import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/message_list_screen/bloc/message_list_screen_bloc.dart';
import 'package:dashboard/screens/message_screen/message_screen.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final int _index;
  final Message _message;
  final MessageListScreenBloc _messageListScreenBloc;
  final MessageRepository _messageRepository;

  const MessageWidget({
    required int index,
    required Message message,
    required MessageListScreenBloc messageListScreenBloc,
    required MessageRepository messageRepository
  })
    : _index = index,
      _message = message,
      _messageListScreenBloc = messageListScreenBloc,
      _messageRepository = messageRepository;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key("message-$_index"),
      child: ListTile(
        key: Key("message-tile-$_index"),
        tileColor: _message.hasUnread ? Colors.white : Colors.grey.shade200,
        title: Text4(
          text: _message.title,
          context: context,
          color: _message.hasUnread 
            ? Theme.of(context).colorScheme.callToAction
            : Theme.of(context).colorScheme.onPrimary,
        ),
        subtitle: Text(
          _message.body,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimarySubdued,
            fontSize: FontSizeAdapter.setSize(size: 2, context: context)
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text5(
          text: DateFormatter.toStringDateTime(date: _message.latestReply),
          context: context
        ),
        onTap: () => _showMessageScreen(context: context),
      ),
    );
  }

  void _showMessageScreen({required BuildContext context}) {
    Navigator.of(context).push(MaterialPageRoute<MessageScreen>(
      fullscreenDialog: true,
      builder: (context) => MessageScreen(
        message: _message,
        messageListScreenBloc: _messageListScreenBloc,
        messageRepository: _messageRepository,
      )
    ));
  }
}