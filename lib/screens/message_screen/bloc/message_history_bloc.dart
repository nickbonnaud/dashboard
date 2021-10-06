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
      super(MessageHistoryState.initial(message: message)) { _eventHandler(); }

  void _eventHandler() {
    on<MarkAsRead>((event, emit) => _mapMarkAsReadState(emit: emit));
    on<ReplyAdded>((event, emit) => _mapReplyAddedToState(event: event, emit: emit));
  }

  void _mapMarkAsReadState({required Emitter<MessageHistoryState> emit}) async {
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
    _updateBlocs(message: message, emit: emit, messageHistoryRead: messageHistoryRead);
    
  }
  
  void _mapReplyAddedToState({required ReplyAdded event, required Emitter<MessageHistoryState> emit}) async {
    final Message message = state.message.update(replies: state.message.replies..insert(0, event.reply), latestReply: DateTime.now());
    _updateBlocs(message: message, emit: emit);
  }

  void _updateBlocs({required Message message, required Emitter<MessageHistoryState> emit, bool messageHistoryRead = false}) async {
    _messageListScreenBloc.add(MessageUpdated(message: message, messageHistoryRead: messageHistoryRead));
    emit(MessageHistoryState(message: message));
  }
}
