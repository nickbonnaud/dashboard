part of 'register_form_bloc.dart';

@immutable
class RegisterFormState extends Equatable {
  final String email;
  final String password;
  final String passwordConfirmation;

  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;

  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid => 
    isEmailValid && email.isNotEmpty &&
    isPasswordValid && password.isNotEmpty &&
    isPasswordConfirmationValid && passwordConfirmation.isNotEmpty;

  const RegisterFormState({
    required this.email,
    required this.password,
    required this.passwordConfirmation,

    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isPasswordConfirmationValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory RegisterFormState.empty() {
    return const RegisterFormState(
      email: "",
      password: "",
      passwordConfirmation: "",

      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop
    );
  }

  RegisterFormState update({
    String? email,
    String? password,
    String? passwordConfirmation,
    
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPasswordConfirmationValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return RegisterFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,

      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordConfirmationValid: isPasswordConfirmationValid ?? this.isPasswordConfirmationValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    passwordConfirmation,

    isEmailValid,
    isPasswordValid,
    isPasswordConfirmationValid,

    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() {
    return '''RegisterFormState {
      email: $email,
      password: $password,
      passwordConfirmation: $passwordConfirmation,

      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isPasswordConfirmationValid: $isPasswordConfirmationValid,

      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: $errorMessage,
      errorButtonControl: $errorButtonControl
    }''';
  }
}
