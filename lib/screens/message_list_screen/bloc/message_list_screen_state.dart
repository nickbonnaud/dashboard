part of 'message_list_screen_bloc.dart';

@immutable
class MessageListScreenState extends Equatable {
  final List<Message> messages;
  final String? nextUrl;
  final bool hasReachedEnd;
  final bool loading;
  final bool paginating;
  final String errorMessage;

  const MessageListScreenState({
    required this.messages,
    this.nextUrl,
    required this.hasReachedEnd,
    required this.loading,
    required this.paginating,
    required this.errorMessage
  });

  factory MessageListScreenState.initial() {
    return const MessageListScreenState(
      messages:  [],
      nextUrl: null,
      hasReachedEnd: false,
      loading: false,
      paginating: false,
      errorMessage: ""
    );
  }

  MessageListScreenState update({
    List<Message>? messages,
    String? nextUrl,
    bool? hasReachedEnd,
    bool? loading,
    bool? paginating,
    String? errorMessage
  }) {
    return MessageListScreenState(
      messages: messages ?? this.messages,
      nextUrl: hasReachedEnd != null && hasReachedEnd ? null : nextUrl ?? this.nextUrl,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      loading: loading ?? this.loading,
      paginating: paginating ?? this.paginating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    nextUrl,
    hasReachedEnd,
    loading,
    paginating,
    errorMessage
  ];
  
  @override
  String toString() => '''MessageListScreenState {
    messages: $messages,
    nextUrl: $nextUrl,
    hasReachedEnd: $hasReachedEnd,
    loading: $loading,
    paginating: $paginating,
    errorMessage: $errorMessage,
  }''';
}
