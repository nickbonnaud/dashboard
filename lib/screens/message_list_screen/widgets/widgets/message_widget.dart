import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/message_list_screen/bloc/message_list_screen_bloc.dart';
import 'package:dashboard/screens/message_list_screen/widgets/widgets/widgets/message_screen.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageWidget extends StatelessWidget {
  final int _index;
  final Message _message;

  const MessageWidget({
    required int index,
    required Message message,
    Key? key
  })
    : _index = index,
      _message = message,
      super(key: key);

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
    final MessageListScreenBloc messageListScreenBloc = BlocProvider.of<MessageListScreenBloc>(context);
    final MessageRepository messageRepository = RepositoryProvider.of<MessageRepository>(context);
    Navigator.of(context).push(MaterialPageRoute<MessageScreen>(
      fullscreenDialog: true,
      builder: (context) => BlocProvider.value(
        value: messageListScreenBloc,
        child: RepositoryProvider.value(
          value: messageRepository,
          child: MessageScreen(message: _message),
        )
      )
    ));
  }
}