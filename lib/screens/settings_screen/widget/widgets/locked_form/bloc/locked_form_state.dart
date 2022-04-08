part of 'locked_form_bloc.dart';

@immutable
class LockedFormState extends Equatable {
  final bool isPasswordValid;
  final bool isSubmitting;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  const LockedFormState({
    required this.isPasswordValid,
    required this.isSubmitting,  
    required this.errorMessage, 
    required this.errorButtonControl
  });

  factory LockedFormState.initial() {
    return const LockedFormState(
      isPasswordValid: true,
      isSubmitting: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop,
    );
  }

  LockedFormState update({
    bool? isPasswordValid,
    bool? isSubmitting,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return LockedFormState(
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl,
    );
  }

  @override
  List<Object?> get props => [
    isPasswordValid,
    isSubmitting,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() => '''LockedFormState {
    isPasswordValid: $isPasswordValid,
    isSubmitting: $isSubmitting,
    errorMessage: $errorMessage,
    errorButtonControl: $errorButtonControl,
  }''';
}
