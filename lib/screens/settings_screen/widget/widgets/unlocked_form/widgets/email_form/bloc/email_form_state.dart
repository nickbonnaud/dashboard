part of 'email_form_bloc.dart';

@immutable
class EmailFormState extends Equatable {
  final String email;

  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;
  
  const EmailFormState({
    required this.email,

    required this.isEmailValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory EmailFormState.initial({required String email}) {
    return EmailFormState(
      email: email,

      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop,
    );
  }

  EmailFormState update({
    String? email,

    bool? isEmailValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return EmailFormState(
      email: email ?? this.email,

      isEmailValid: isEmailValid ?? this.isEmailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl,
    );
  }

  @override
  List<Object?> get props => [
    email,

    isEmailValid,
    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() => '''UnlockedFormState {
    email: $email,
    
    isEmailValid: $isEmailValid,
    isSubmitting: $isSubmitting,
    isSuccess: $isSuccess,
    errorMessage: $errorMessage,
    errorButtonControl: $errorButtonControl,
  }''';
}
