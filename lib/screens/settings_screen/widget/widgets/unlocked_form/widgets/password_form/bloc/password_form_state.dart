part of 'password_form_bloc.dart';

@immutable
class PasswordFormState extends Equatable {
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  PasswordFormState({
    required this.isPasswordValid,
    required this.isPasswordConfirmationValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory PasswordFormState.initial() {
    return PasswordFormState(
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.STOP,
    );
  }

  PasswordFormState update({
    bool? isPasswordValid,
    bool? isPasswordConfirmationValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return PasswordFormState(
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordConfirmationValid: isPasswordConfirmationValid ?? this.isPasswordConfirmationValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl,
    );
  }

  @override
  List<Object?> get props => [
    isPasswordValid,
    isPasswordConfirmationValid,
    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() => '''PasswordFormState {
    isPasswordValid: $isPasswordValid,
    isPasswordConfirmationValid: $isPasswordConfirmationValid,
    isSubmitting: $isSubmitting,
    isSuccess: $isSuccess,
    errorMessage: $errorMessage,
    errorButtonControl: $errorButtonControl,
  }''';
}
