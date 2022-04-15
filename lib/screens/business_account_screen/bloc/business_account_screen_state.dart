part of 'business_account_screen_bloc.dart';

@immutable
class BusinessAccountScreenState extends Equatable {
  final EntityType entityType;
  final String name;
  final String address;
  final String addressSecondary;
  final String city;
  final String state;
  final String zip;
  final String ein;
  
  final bool isNameValid;
  final bool isAddressValid;
  final bool isAddressSecondaryValid;
  final bool isCityValid;
  final bool isStateValid;
  final bool isZipValid;
  final bool isEinValid;

  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  bool get isFormValid => 
    entityType != EntityType.unknown &&
    isNameValid && name.isNotEmpty &&
    isAddressValid && address.isNotEmpty &&
    isAddressSecondaryValid &&
    isCityValid && city.isNotEmpty &&
    isStateValid && state.isNotEmpty &&
    isZipValid && zip.isNotEmpty &&
    isEinValid;

  const BusinessAccountScreenState({
    required this.entityType,
    required this.name,
    required this.address,
    required this.addressSecondary,
    required this.city,
    required this.state,
    required this.zip,
    required this.ein,

    required this.isNameValid,
    required this.isAddressValid,
    required this.isAddressSecondaryValid,
    required this.isCityValid,
    required this.isStateValid,
    required this.isZipValid,
    required this.isEinValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory BusinessAccountScreenState.empty({required BusinessAccount businessAccount}) {
    return BusinessAccountScreenState(
      entityType: businessAccount.entityType,
      name: businessAccount.businessName,
      address: businessAccount.address.address,
      addressSecondary: businessAccount.address.addressSecondary ?? "",
      city: businessAccount.address.city,
      state: businessAccount.address.state,
      zip: businessAccount.address.zip,
      ein: businessAccount.ein ?? "",

      isNameValid: true,
      isAddressValid: true,
      isAddressSecondaryValid: true,
      isCityValid: true,
      isStateValid: true,
      isZipValid: true,
      isEinValid: true,

      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop
    );
  }

  BusinessAccountScreenState update({
    EntityType? entityType,
    String? name,
    String? address,
    String? addressSecondary,
    String? city,
    String? state,
    String? zip,
    String? ein,

    bool? isNameValid,
    bool? isAddressValid,
    bool? isAddressSecondaryValid,
    bool? isCityValid,
    bool? isStateValid,
    bool? isZipValid,
    bool? isEinValid,

    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl,
  }) {
    return _copyWith(
      entityType: entityType,
      name: name,
      address: address,
      addressSecondary: addressSecondary,
      city: city,
      state: state,
      zip: zip,
      ein: ein,

      isNameValid: isNameValid,
      isAddressValid: isAddressValid,
      isAddressSecondaryValid: isAddressSecondaryValid,
      isCityValid: isCityValid,
      isStateValid: isStateValid,
      isZipValid: isZipValid,
      isEinValid: isEinValid,

      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      isFailure: isFailure,
      errorMessage: errorMessage,
      errorButtonControl: errorButtonControl,
    );
  }
  
  BusinessAccountScreenState _copyWith({
    EntityType? entityType,
    String? name,
    String? address,
    String? addressSecondary,
    String? city,
    String? state,
    String? zip,
    String? ein,

    bool? isNameValid,
    bool? isAddressValid,
    bool? isAddressSecondaryValid,
    bool? isCityValid,
    bool? isStateValid,
    bool? isZipValid,
    bool? isEinValid,

    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl,
  }) {
    return BusinessAccountScreenState(
      entityType: entityType ?? this.entityType,
      name: name ?? this.name,
      address: address ?? this.address,
      addressSecondary: addressSecondary ?? this.addressSecondary,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      ein: ein ?? this.ein,

      isNameValid: isNameValid ?? this.isNameValid,
      isAddressValid: isAddressValid ?? this.isAddressValid,
      isAddressSecondaryValid: isAddressSecondaryValid ?? this.isAddressSecondaryValid,
      isCityValid: isCityValid ?? this.isCityValid,
      isStateValid: isStateValid ?? this.isStateValid,
      isZipValid: isZipValid ?? this.isZipValid,
      isEinValid: isEinValid ?? this.isEinValid,

      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl
    );
  }

  @override
  List<Object?> get props => [
    entityType,
    name,
    address,
    addressSecondary,
    city,
    state,
    zip,
    ein,

    isNameValid,
    isAddressValid,
    isAddressSecondaryValid,
    isCityValid,
    isStateValid,
    isZipValid,
    isEinValid,

    isSubmitting,
    isSuccess,
    isFailure,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() {
    return '''BusinessAccountScreenState {
      entityType: $entityType,
      name: $name
      address: $address,
      addressSecondary: $addressSecondary,
      city: $city,
      state: $state,
      zip: $zip,
      ein: $ein,

      isNameValid: $isNameValid,
      isAddressValid: $isAddressValid,
      isAddressSecondaryValid: $isAddressSecondaryValid,
      isCityValid: $isCityValid,
      isStateValid: $isStateValid,
      isZipValid: $isZipValid,
      isEinValid: $isEinValid,

      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      errorMessage: $errorMessage,
      errorButtonControl: $errorButtonControl,
    }''';
  }
}
