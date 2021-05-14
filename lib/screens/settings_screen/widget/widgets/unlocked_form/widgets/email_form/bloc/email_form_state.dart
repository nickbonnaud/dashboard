part of 'email_form_bloc.dart';

@immutable
class EmailFormState extends Equatable {
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;
  
  EmailFormState({
    required this.isEmailValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory EmailFormState.initial() {
    return EmailFormState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.STOP,
    );
  }

  EmailFormState update({
    bool? isEmailValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return EmailFormState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl,
    );
  }

  @override
  List<Object?> get props => [
    isEmailValid,
    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() => '''UnlockedFormState {
    isEmailValid: $isEmailValid,
    isSubmitting: $isSubmitting,
    isSuccess: $isSuccess,
    errorMessage: $errorMessage,
    errorButtonControl: $errorButtonControl,
  }''';
}
