part of 'owner_form_bloc.dart';

@immutable
class OwnerFormState extends Equatable {
  final bool isPrimary;
  final String firstName;
  final String lastName;
  final String title;
  final String phone;
  final String email;
  final String percentOwnership;
  final String dob;
  final String ssn;
  final String address;
  final String addressSecondary;
  final String city;
  final String state;
  final String zip;

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
    isFirstNameValid && firstName.isNotEmpty &&
    isLastNameValid && lastName.isNotEmpty &&
    isTitleValid && title.isNotEmpty &&
    isPhoneValid && phone.isNotEmpty &&
    isEmailValid && email.isNotEmpty &&
    isPercentOwnershipValid && percentOwnership.isNotEmpty &&
    isDobValid && dob.isNotEmpty &&
    isSsnValid && ssn.isNotEmpty &&
    isAddressValid && address.isNotEmpty &&
    isAddressSecondaryValid &&
    isCityValid && city.isNotEmpty &&
    isStateValid && state.isNotEmpty &&
    isZipValid && zip.isNotEmpty;

  const OwnerFormState({
    required this.isPrimary,
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.phone,
    required this.email,
    required this.percentOwnership,
    required this.dob,
    required this.ssn,
    required this.address,
    required this.addressSecondary,
    required this.city,
    required this.state,
    required this.zip,

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

  factory OwnerFormState.empty({OwnerAccount? ownerAccount}) {
    return OwnerFormState(
      isPrimary: ownerAccount?.primary ?? false,
      firstName: ownerAccount?.firstName ?? '',
      lastName: ownerAccount?.lastName ?? '',
      title: ownerAccount?.title ?? '',
      phone: ownerAccount?.phone ?? '',
      email: ownerAccount?.email ?? '',
      percentOwnership: ownerAccount?.percentOwnership.toString() ?? '',
      dob: ownerAccount?.dob ?? '',
      ssn: ownerAccount?.ssn ?? '',
      address: ownerAccount?.address.address ?? '',
      addressSecondary: ownerAccount?.address.addressSecondary ?? "",
      city: ownerAccount?.address.city ?? '',
      state: ownerAccount?.address.state ?? '',
      zip: ownerAccount?.address.zip ?? '',

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
    String? firstName,
    String? lastName,
    String? title,
    String? phone,
    String? email,
    String? percentOwnership,
    String? dob,
    String? ssn,
    String? address,
    String? addressSecondary,
    String? city,
    String? state,
    String? zip,

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
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      title: title ?? this.title,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      percentOwnership: percentOwnership ?? this.percentOwnership,
      dob: dob ?? this.dob,
      ssn: ssn ?? this.ssn,
      address: address ?? this.address,
      addressSecondary: addressSecondary ?? this.addressSecondary,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,

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
    firstName,
    lastName,
    title,
    phone,
    email,
    percentOwnership,
    dob,
    ssn,
    address,
    addressSecondary,
    city,
    state,
    zip,

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
      firstName: $firstName,
      lastName: $lastName,
      title: $title,
      phone: $phone,
      email: $email,
      percentOwnership: $percentOwnership,
      dob: $dob,
      ssn: $ssn,
      address: $address,
      addressSecondary: $addressSecondary,
      city: $city,
      state: $state,
      zip: $zip,

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

