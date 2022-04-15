part of 'bank_screen_bloc.dart';

@immutable
class BankScreenState extends Equatable {
  final String firstName;
  final String lastName;
  final String routingNumber;
  final String accountNumber;
  final AccountType accountType;
  final String address;
  final String addressSecondary;
  final String city;
  final String state;
  final String zip;


  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isRoutingNumberValid;
  final bool isAccountNumberValid;
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

  bool get isFormValid => 
    accountType != AccountType.unknown &&
    isFirstNameValid && firstName.isNotEmpty &&
    isLastNameValid && lastName.isNotEmpty &&
    isRoutingNumberValid && routingNumber.isNotEmpty &&
    isAccountNumberValid && accountNumber.isNotEmpty &&
    isAddressValid && address.isNotEmpty &&
    isAddressSecondaryValid &&
    isCityValid && city.isNotEmpty &&
    isStateValid && state.isNotEmpty &&
    isZipValid && zip.isNotEmpty;

  const BankScreenState({
    required this.firstName,
    required this.lastName,
    required this.routingNumber,
    required this.accountNumber,
    required this.accountType,
    required this.address,
    required this.addressSecondary,
    required this.city,
    required this.state,
    required this.zip,

    required this.isFirstNameValid,
    required this.isLastNameValid,
    required this.isRoutingNumberValid,
    required this.isAccountNumberValid,
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

  factory BankScreenState.empty({required BankAccount bankAccount}) {
    return BankScreenState(
      firstName: bankAccount.firstName,
      lastName: bankAccount.lastName,
      routingNumber: bankAccount.routingNumber,
      accountNumber: bankAccount.accountNumber,
      accountType: bankAccount.accountType,
      address: bankAccount.address.address,
      addressSecondary: bankAccount.address.addressSecondary ?? "",
      city: bankAccount.address.city,
      state: bankAccount.address.state,
      zip: bankAccount.address.zip,

      isFirstNameValid: true,
      isLastNameValid: true,
      isRoutingNumberValid: true,
      isAccountNumberValid: true,
      isAddressValid: true,
      isAddressSecondaryValid: true,
      isCityValid: true,
      isStateValid: true,
      isZipValid: true,
      
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop
    );
  }

  BankScreenState update({
    String? firstName,
    String? lastName,
    String? routingNumber,
    String? accountNumber,
    AccountType? accountType,
    String? address,
    String? addressSecondary,
    String? city,
    String? state,
    String? zip,
    
    bool? isFirstNameValid,
    bool? isLastNameValid,
    bool? isRoutingNumberValid,
    bool? isAccountNumberValid,
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
      firstName: firstName,
      lastName: lastName,
      routingNumber: routingNumber,
      accountNumber: accountNumber,
      accountType: accountType,
      address: address,
      addressSecondary: addressSecondary,
      city: city,
      state: state,
      zip: zip,

      isFirstNameValid: isFirstNameValid,
      isLastNameValid: isLastNameValid,
      isRoutingNumberValid: isRoutingNumberValid,
      isAccountNumberValid: isAccountNumberValid,
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
    String? firstName,
    String? lastName,
    String? routingNumber,
    String? accountNumber,
    AccountType? accountType,
    String? address,
    String? addressSecondary,
    String? city,
    String? state,
    String? zip,
    
    bool? isFirstNameValid,
    bool? isLastNameValid,
    bool? isRoutingNumberValid,
    bool? isAccountNumberValid,
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
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      routingNumber: routingNumber ?? this.routingNumber,
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
      address: address ?? this.address,
      addressSecondary: addressSecondary ?? this.addressSecondary,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,

      isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
      isLastNameValid: isLastNameValid ?? this.isLastNameValid,
      isRoutingNumberValid: isRoutingNumberValid ?? this.isRoutingNumberValid,
      isAccountNumberValid: isAccountNumberValid ?? this.isAccountNumberValid,
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
    firstName,
    lastName,
    routingNumber,
    accountNumber,
    accountType,
    address,
    addressSecondary,
    city,
    state,
    zip,
    
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
      firstName: $firstName,
      lastName: $lastName,
      routingNumber: $routingNumber,
      accountNumber: $accountNumber,
      accountType: $accountType,
      address: $address,
      addressSecondary: $addressSecondary,
      city: $city,
      state: $state,
      zip: $zip,

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
