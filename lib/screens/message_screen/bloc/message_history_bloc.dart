import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/screens/message_list_screen/bloc/message_list_screen_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'message_history_event.dart';
part 'message_history_state.dart';

class MessageHistoryBloc extends Bloc<MessageHistoryEvent, MessageHistoryState> {
  final MessageListScreenBloc _messageListScreenBloc;
  
  MessageHistoryBloc({required MessageListScreenBloc messageListScreenBloc, required Message message}) 
    : _messageListScreenBloc = messageListScreenBloc,
      super(MessageHistoryState.initial(message: message));

  @override
  Stream<MessageHistoryState> mapEventToState(MessageHistoryEvent event) async* {
    if (event is MarkAsRead) {
      yield* _mapMarkAsReadState();
    } else if (event is ReplyAdded) {
      yield* _mapReplyAddedToState(event: event);
    }
  }

  Stream<MessageHistoryState> _mapMarkAsReadState() async* {
    final bool messageHistoryRead = state.message.hasUnread;
    
    List<Reply> replies = state.message.replies.map((reply) {
      if (!reply.read && !reply.fromBusiness) {
        return reply.update(read: true);
      }
      return reply;
    }).toList();

    final Message message = state.message.update(
      replies: replies, 
      read: state.message.fromBusiness ? state.message.read : true
    );
    yield* _updateBlocs(message: message, messageHistoryRead: messageHistoryRead);
    
  }
  
  Stream<MessageHistoryState> _mapReplyAddedToState({required ReplyAdded event}) async* {
    final Message message = state.message.update(replies: state.message.replies..insert(0, event.reply), latestReply: DateTime.now());
    yield* _updateBlocs(message: message);
  }

  Stream<MessageHistoryState> _updateBlocs({required Message message, bool messageHistoryRead = false}) async* {
    _messageListScreenBloc.add(MessageUpdated(message: message, messageHistoryRead: messageHistoryRead));
    yield MessageHistoryState(message: message);
  }
}
