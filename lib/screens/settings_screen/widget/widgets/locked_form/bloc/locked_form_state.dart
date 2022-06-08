part of 'locked_form_bloc.dart';

@immutable
class LockedFormState extends Equatable {
  final String password;
  final bool isPasswordValid;

  final bool isSubmitting;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid => isPasswordValid && password.isNotEmpty;
  
  const LockedFormState({
    required this.password,
    required this.isPasswordValid,

    required this.isSubmitting,  
    required this.errorMessage, 
    required this.errorButtonControl
  });

  factory LockedFormState.initial() {
    return const LockedFormState(
      password: "",
      isPasswordValid: false,

      isSubmitting: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop,
    );
  }

  LockedFormState update({
    String? password,
    bool? isPasswordValid,

    bool? isSubmitting,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return LockedFormState(
      password: password ?? this.password,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,

      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl,
    );
  }

  @override
  List<Object?> get props => [
    password,
    isPasswordValid,

    isSubmitting,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() => '''LockedFormState {
    password: $password,
    isPasswordValid: $isPasswordValid,

    isSubmitting: $isSubmitting,
    errorMessage: $errorMessage,
    errorButtonControl: $errorButtonControl,
  }''';
}
