part of 'message_list_screen_bloc.dart';

abstract class MessageListScreenEvent extends Equatable {
  const MessageListScreenEvent();

  @override
  List<Object> get props => [];
}

class Init extends MessageListScreenEvent {}

class FetchMore extends MessageListScreenEvent {}

class MessageUpdated extends MessageListScreenEvent {
  final Message message;
  final bool messageHistoryRead;

  const MessageUpdated({required this.message, required this.messageHistoryRead});

  @override
  List<Object> get props => [message, messageHistoryRead];

  @override
  String toString() => 'MessageUpdated { message: $message, messageHistoryRead: $messageHistoryRead }';
}