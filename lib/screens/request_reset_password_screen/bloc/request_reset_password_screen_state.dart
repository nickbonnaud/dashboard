part of 'request_reset_password_screen_bloc.dart';

class RequestResetPasswordScreenState extends Equatable {
  final String email;
  final bool isEmailValid;
  
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid => isEmailValid && email.isNotEmpty;
  
  const RequestResetPasswordScreenState({
    required this.email,
    required this.isEmailValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory RequestResetPasswordScreenState.initial() {
    return const RequestResetPasswordScreenState(
      email: "",
      isEmailValid: true,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop
    );
  }

  RequestResetPasswordScreenState update({
    String? email,
    bool? isEmailValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return RequestResetPasswordScreenState(
      email: email ?? this.email,
      isEmailValid: isEmailValid ?? this.isEmailValid,

      isSubmitting: isSubmitting ?? this.isSubmitting, 
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl
    );
  }

  @override
  List<Object> get props => [
    email,
    isEmailValid,

    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() {
    return '''RequestResetPasswordScreenState {
      email: $email,
      isEmailValid: $isEmailValid,

      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: $errorMessage,
      errorButtonControl: $errorButtonControl
    }''';
  }
}
