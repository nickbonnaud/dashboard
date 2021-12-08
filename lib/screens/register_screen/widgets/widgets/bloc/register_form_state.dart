part of 'register_form_bloc.dart';

@immutable
class RegisterFormState extends Equatable {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid => isEmailValid && isPasswordValid && isPasswordConfirmationValid;

  RegisterFormState({
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isPasswordConfirmationValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory RegisterFormState.empty() {
    return RegisterFormState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop
    );
  }

  factory RegisterFormState.loading() {
    return RegisterFormState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: true,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop
    );
  }

  factory RegisterFormState.failure({required String errorMessage}) {
    return RegisterFormState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: errorMessage,
      errorButtonControl: CustomAnimationControl.playFromStart
    );
  }

  factory RegisterFormState.success() {
    return RegisterFormState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: false,
      isSuccess: true,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop
    );
  }

  RegisterFormState update({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPasswordConfirmationValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return RegisterFormState(
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
