part of 'message_history_bloc.dart';

@immutable
class MessageHistoryState extends Equatable {
  final Message message;

  const MessageHistoryState({required this.message});

  factory MessageHistoryState.initial({required Message message}) {
    return MessageHistoryState(message: message);
  }

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'MessageHistoryState { message: $message }';
}
