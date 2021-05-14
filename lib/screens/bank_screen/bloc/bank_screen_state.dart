part of 'bank_screen_bloc.dart';

@immutable
class BankScreenState extends Equatable {
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isRoutingNumberValid;
  final bool isAccountNumberValid;
  final AccountType accountType;
  final bool isAddressValid;
  final bool isAddressSecondaryValid;
  final bool isCityValid;
  final bool isStateValid;
  final bool isZipValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid => accountType != AccountType.unknown &&
    isFirstNameValid &&
    isLastNameValid &&
    isRoutingNumberValid &&
    isAccountNumberValid &&
    isAddressValid &&
    isAddressSecondaryValid &&
    isCityValid &&
    isStateValid &&
    isZipValid;

  BankScreenState({
    required this.isFirstNameValid,
    required this.isLastNameValid,
    required this.isRoutingNumberValid,
    required this.isAccountNumberValid,
    required this.accountType,
    required this.isAddressValid,
    required this.isAddressSecondaryValid,
    required this.isCityValid,
    required this.isStateValid,
    required this.isZipValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory BankScreenState.empty({required AccountType accountType}) {
    return BankScreenState(
      isFirstNameValid: true,
      isLastNameValid: true,
      isRoutingNumberValid: true,
      isAccountNumberValid: true,
      accountType: accountType,
      isAddressValid: true,
      isAddressSecondaryValid: true,
      isCityValid: true,
      isStateValid: true,
      isZipValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.STOP
    );
  }

  BankScreenState update({
    bool? isFirstNameValid,
    bool? isLastNameValid,
    bool? isRoutingNumberValid,
    bool? isAccountNumberValid,
    AccountType? accountType,
    bool? isAddressValid,
    bool? isAddressSecondaryValid,
    bool? isCityValid,
    bool? isStateValid,
    bool? isZipValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl,
  }) {
    return _copyWith(
      isFirstNameValid: isFirstNameValid,
      isLastNameValid: isLastNameValid,
      isRoutingNumberValid: isRoutingNumberValid,
      isAccountNumberValid: isAccountNumberValid,
      accountType: accountType,
      isAddressValid: isAddressValid,
      isAddressSecondaryValid: isAddressSecondaryValid,
      isCityValid: isCityValid,
      isStateValid: isStateValid,
      isZipValid: isZipValid,
      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      isFailure: isFailure,
      errorMessage: errorMessage,
      errorButtonControl: errorButtonControl,
    );
  }
  
  BankScreenState _copyWith({
    bool? isFirstNameValid,
    bool? isLastNameValid,
    bool? isRoutingNumberValid,
    bool? isAccountNumberValid,
    AccountType? accountType,
    bool? isAddressValid,
    bool? isAddressSecondaryValid,
    bool? isCityValid,
    bool? isStateValid,
    bool? isZipValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl,
  }) {
    return BankScreenState(
      isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
      isLastNameValid: isLastNameValid ?? this.isLastNameValid,
      isRoutingNumberValid: isRoutingNumberValid ?? this.isRoutingNumberValid,
      isAccountNumberValid: isAccountNumberValid ?? this.isAccountNumberValid,
      accountType: accountType ?? this.accountType,
      isAddressValid: isAddressValid ?? this.isAddressValid,
      isAddressSecondaryValid: isAddressSecondaryValid ?? this.isAddressSecondaryValid,
      isCityValid: isCityValid ?? this.isCityValid,
      isStateValid: isStateValid ?? this.isStateValid,
      isZipValid: isZipValid ?? this.isZipValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl
    );
  }

  @override
  List<Object?> get props => [
    isFirstNameValid,
    isLastNameValid,
    isRoutingNumberValid,
    isAccountNumberValid,
    accountType,
    isAddressValid,
    isAddressSecondaryValid,
    isCityValid,
    isStateValid,
    isZipValid,
    isSubmitting,
    isSuccess,
    isFailure,
    errorMessage,
    errorButtonControl
  ];

  @override
  String toString() {
    return '''BankScreenState {
      isFirstNameValid: $isFirstNameValid,
      isLastNameValid: $isLastNameValid,
      isRoutingNumberValid: $isRoutingNumberValid,
      isAccountNumberValid: $isAccountNumberValid,
      accountType: $accountType,
      isAddressValid: $isAddressValid,
      isAddressSecondaryValid: $isAddressSecondaryValid,
      isCityValid: $isCityValid,
      isStateValid: $isStateValid,
      isZipValid: $isZipValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      errorMessage: $errorMessage,
      errorButtonControl: $errorButtonControl
    }''';
  }
}
