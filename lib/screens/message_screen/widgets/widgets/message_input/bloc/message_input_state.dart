part of 'message_input_bloc.dart';

@immutable
class MessageInputState extends Equatable {
  final bool isInputValid;
  final bool isSubmitting;
  final String errorMessage;

  const MessageInputState({
    required this.isInputValid,
    required this.isSubmitting,
    required this.errorMessage
  });

  factory MessageInputState.initial() {
    return const MessageInputState(
      isInputValid: true,
      isSubmitting: false,
      errorMessage: ""
    );
  }

  MessageInputState update({
    bool? isInputValid,
    bool? isSubmitting,
    String? errorMessage
  }) {
    return MessageInputState(
      isInputValid: isInputValid ?? this.isInputValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object?> get props => [
    isInputValid,
    isSubmitting,
    errorMessage
  ];
  
  @override
  String toString() => 'MessageInputState { isInputValid: $isInputValid, isSubmitting: $isSubmitting, errorMessage: $errorMessage }';
}

