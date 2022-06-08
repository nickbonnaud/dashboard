part of 'name_field_bloc.dart';

@immutable
class NameFieldState extends Equatable {
  final String firstName;
  final String lastName;

  final bool isFirstNameValid;
  final bool isLastNameValid;
  
  const NameFieldState({
    required this.firstName,
    required this.lastName,

    required this.isFirstNameValid,
    required this.isLastNameValid,
  });

  factory NameFieldState.initial({required String firstName, required String lastName}) {
    return NameFieldState(
      firstName: firstName,
      lastName: lastName,

      isFirstNameValid: firstName.isNotEmpty,
      isLastNameValid: lastName.isNotEmpty,
    );
  }

  NameFieldState update({
    String? firstName,
    String? lastName,

    bool? isFirstNameValid, 
    bool? isLastNameValid,
  }) {
    return NameFieldState(firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,

      isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
      isLastNameValid: isLastNameValid ?? this.isLastNameValid
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,

    isFirstNameValid, 
    isLastNameValid,
  ];
  
  @override
  String toString() => '''NameFieldState { 
    firstName: $firstName,
    lastName: $lastName,

    isFirstNameValid: $isFirstNameValid,
    isLastNameValid: $isLastNameValid
  }''';
}
