part of 'owner_form_bloc.dart';

@immutable
class OwnerFormState extends Equatable {
  final bool isPrimary;
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isTitleValid;
  final bool isPhoneValid;
  final bool isEmailValid;
  final bool isPercentOwnershipValid;
  final bool isDobValid;
  final bool isSsnValid;
  final bool isAddressValid;
  final bool isAddressSecondaryValid;
  final bool isCityValid;
  final bool isStateValid;
  final bool isZipValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid =>
    isFirstNameValid &&
    isLastNameValid &&
    isTitleValid &&
    isPhoneValid &&
    isEmailValid &&
    isPercentOwnershipValid &&
    isDobValid &&
    isSsnValid &&
    isAddressValid &&
    isAddressSecondaryValid &&
    isCityValid &&
    isStateValid &&
    isZipValid;

  OwnerFormState({
    required this.isPrimary,
    required this.isFirstNameValid,
    required this.isLastNameValid,
    required this.isTitleValid,
    required this.isPhoneValid,
    required this.isEmailValid,
    required this.isPercentOwnershipValid,
    required this.isDobValid,
    required this.isSsnValid,
    required this.isAddressValid,
    required this.isAddressSecondaryValid,
    required this.isCityValid,
    required this.isStateValid,
    required this.isZipValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory OwnerFormState.empty() {
    return OwnerFormState(
      isPrimary: false,
      isFirstNameValid: true,
      isLastNameValid: true,
      isTitleValid: true,
      isPhoneValid: true,
      isEmailValid: true,
      isPercentOwnershipValid: true,
      isDobValid: true,
      isSsnValid: true,
      isAddressValid: true,
      isAddressSecondaryValid: true,
      isCityValid: true,
      isStateValid: true,
      isZipValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop
    );
  }

  OwnerFormState update({
    bool? isPrimary,
    bool? isFirstNameValid,
    bool? isLastNameValid,
    bool? isTitleValid,
    bool? isPhoneValid,
    bool? isEmailValid,
    bool? isPercentOwnershipValid,
    bool? isDobValid,
    bool? isSsnValid,
    bool? isAddressValid,
    bool? isAddressSecondaryValid,
    bool? isCityValid,
    bool? isStateValid,
    bool? isZipValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return OwnerFormState(
      isPrimary: isPrimary ?? this.isPrimary,
      isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid, 
      isLastNameValid: isLastNameValid ?? this.isLastNameValid, 
      isTitleValid: isTitleValid ?? this.isTitleValid, 
      isPhoneValid: isPhoneValid ?? this.isPhoneValid, 
      isEmailValid: isEmailValid ?? this.isEmailValid, 
      isPercentOwnershipValid: isPercentOwnershipValid ?? this.isPercentOwnershipValid, 
      isDobValid: isDobValid ?? this.isDobValid, 
      isSsnValid: isSsnValid ?? this.isSsnValid, 
      isAddressValid: isAddressValid ?? this.isAddressValid, 
      isAddressSecondaryValid: isAddressSecondaryValid ?? this.isAddressSecondaryValid, 
      isCityValid: isCityValid ?? this.isCityValid, 
      isStateValid: isStateValid ?? this.isStateValid, 
      isZipValid: isZipValid ?? this.isZipValid, 
      isSubmitting: isSubmitting ?? this.isSubmitting, 
      isSuccess: isSuccess ?? this.isSuccess, 
      errorMessage: errorMessage ?? this.errorMessage, 
      errorButtonControl: errorButtonControl ?? this.errorButtonControl
    );
  }

  @override
  List<Object> get props => [
    isPrimary,
    isFirstNameValid,
    isLastNameValid,
    isTitleValid,
    isPhoneValid,
    isEmailValid,
    isPercentOwnershipValid,
    isDobValid,
    isSsnValid,
    isAddressValid,
    isAddressSecondaryValid,
    isCityValid,
    isStateValid,
    isZipValid,
    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() {
    return '''OwnerFormState {
      isPrimary: $isPrimary,
      isFirstNameValid: $isFirstNameValid, 
      isLastNameValid: $isLastNameValid, 
      isTitleValid: $isTitleValid, 
      isPhoneValid: $isPhoneValid, 
      isEmailValid: $isEmailValid, 
      isPercentOwnershipValid: $isPercentOwnershipValid, 
      isDobValid: $isDobValid, 
      isSsnValid: $isSsnValid, 
      isAddressValid: $isAddressValid, 
      isAddressSecondaryValid: $isAddressSecondaryValid, 
      isCityValid: $isCityValid, 
      isStateValid: $isStateValid, 
      isZipValid: $isZipValid, 
      isSubmitting: $isSubmitting, 
      isSuccess: $isSuccess, 
      errorMessage: $errorMessage, 
      errorButtonControl: $errorButtonControl
    }''';
  }
}

