part of 'password_form_bloc.dart';

@immutable
class PasswordFormState extends Equatable {
  final String password;
  final String passwordConfirmation;

  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;

  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid => isPasswordValid && password.isNotEmpty && isPasswordConfirmationValid && passwordConfirmation.isNotEmpty;
  
  const PasswordFormState({
    required this.password,
    required this.passwordConfirmation,

    required this.isPasswordValid,
    required this.isPasswordConfirmationValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory PasswordFormState.initial() {
    return const PasswordFormState(
      password: "",
      passwordConfirmation: "",

      isPasswordValid: false,
      isPasswordConfirmationValid: false,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop,
    );
  }

  PasswordFormState update({
    String? password,
    String? passwordConfirmation,

    bool? isPasswordValid,
    bool? isPasswordConfirmationValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return PasswordFormState(
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,

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
    password,
    passwordConfirmation,

    isPasswordValid,
    isPasswordConfirmationValid,

    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() => '''PasswordFormState {
    password: $password,
    passwordConfirmation: $passwordConfirmation,

    isPasswordValid: $isPasswordValid,
    isPasswordConfirmationValid: $isPasswordConfirmationValid,

    isSubmitting: $isSubmitting,
    isSuccess: $isSuccess,
    errorMessage: $errorMessage,
    errorButtonControl: $errorButtonControl,
  }''';
}
