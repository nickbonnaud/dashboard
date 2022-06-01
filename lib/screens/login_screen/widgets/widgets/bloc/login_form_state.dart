part of 'login_form_bloc.dart';

@immutable
class LoginFormState extends Equatable {
  final String email;
  final String password;

  final bool isEmailValid;
  final bool isPasswordValid;

  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid => isEmailValid && email.isNotEmpty && isPasswordValid && password.isNotEmpty;

  const LoginFormState({
    required this.email,
    required this.password,

    required this.isEmailValid,
    required this.isPasswordValid,
    
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory LoginFormState.empty() {
    return const LoginFormState(
      email: "",
      password: "",

      isEmailValid: true,
      isPasswordValid: true,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop
    );
  }

  LoginFormState update({
    String? email,
    String? password,

    bool? isEmailValid, 
    bool? isPasswordValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,

      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,

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

    isEmailValid,
    isPasswordValid,

    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() {
    return '''LoginFormState {
      email: $email,
      password: $password,

      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,

      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: $errorMessage,
      errorButtonControl: $errorButtonControl
    } ''';
  }
}