part of 'business_account_screen_bloc.dart';

@immutable
class BusinessAccountScreenState extends Equatable {
  final EntityType entityType;
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

  bool get isFormValid => entityType != EntityType.unknown &&
    isNameValid &&
    isAddressValid &&
    isAddressSecondaryValid &&
    isCityValid &&
    isStateValid &&
    isZipValid &&
    isEinValid;

  BusinessAccountScreenState({
    required this.entityType,
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

  factory BusinessAccountScreenState.empty({required EntityType entityType}) {
    return BusinessAccountScreenState(
      entityType: entityType,
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
