part of 'reset_password_screen_bloc.dart';

@immutable
class ResetPasswordScreenState extends Equatable {
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid => isPasswordValid && isPasswordConfirmationValid;

  ResetPasswordScreenState({
    required this.isPasswordValid,
    required this.isPasswordConfirmationValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory ResetPasswordScreenState.initial() {
    return ResetPasswordScreenState(
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop
    );
  }

  ResetPasswordScreenState update({
    bool? isPasswordValid,
    bool? isPasswordConfirmationValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return ResetPasswordScreenState(
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordConfirmationValid: isPasswordConfirmationValid ?? this.isPasswordConfirmationValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl
    );
  }

  @override
  List<Object> get props => [
    isPasswordValid,
    isPasswordConfirmationValid,
    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() => '''ResetPasswordScreenState {
    isPasswordValid: $isPasswordValid,
    isPasswordConfirmationValid: $isPasswordConfirmationValid,
    isSubmitting: $isSubmitting,
    isSuccess: $isSuccess,
    errorMessage: $errorMessage,
    errorButtonControl: $errorButtonControl
  }''';
}

