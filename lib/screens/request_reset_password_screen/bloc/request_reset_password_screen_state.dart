part of 'request_reset_password_screen_bloc.dart';

class RequestResetPasswordScreenState extends Equatable {
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  RequestResetPasswordScreenState({
    required this.isEmailValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory RequestResetPasswordScreenState.initial() {
    return RequestResetPasswordScreenState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.STOP
    );
  }

  RequestResetPasswordScreenState update({
    bool? isEmailValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return RequestResetPasswordScreenState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting, 
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl
    );
  }

  @override
  List<Object> get props => [
    isEmailValid,
    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() {
    return '''RequestResetPasswordScreenState {
      isEmailValid: $isEmailValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: $errorMessage,
      errorButtonControl: $errorButtonControl
    }''';
  }
}
