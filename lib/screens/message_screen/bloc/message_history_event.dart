part of 'message_history_bloc.dart';

abstract class MessageHistoryEvent extends Equatable {
  const MessageHistoryEvent();

  @override
  List<Object> get props => [];
}

class MarkAsRead extends MessageHistoryEvent {}

class ReplyAdded extends MessageHistoryEvent {
  final Reply reply;

  const ReplyAdded({required this.reply});

  @override
  List<Object> get props => [reply];

  @override
  String toString() => 'ReplyAdded { reply: $reply }';
}
