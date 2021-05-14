part of 'messages_bloc.dart';

@immutable
class MessagesState extends Equatable {
  final bool hasUnreadMessages;
  final bool loading;
  final String errorMessage;

  MessagesState({required this.hasUnreadMessages, required this.loading, required this.errorMessage});

  factory MessagesState.initial() {
    return MessagesState(
      hasUnreadMessages: false,
      loading: false,
      errorMessage: ""
    );
  }

  MessagesState update({bool? hasUnreadMessages, bool? loading, String? errorMessage}) {
    return MessagesState(
      hasUnreadMessages: hasUnreadMessages ?? this.hasUnreadMessages,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object?> get props => [hasUnreadMessages, loading, errorMessage];

  @override
  String toString() => 'MessagesState { hasUnreadMessages: $hasUnreadMessages, loading: $loading, errorMessage: $errorMessage }';
}

