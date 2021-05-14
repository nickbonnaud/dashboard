part of 'name_field_bloc.dart';

@immutable
class NameFieldState extends Equatable {
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final String firstName;
  final String lastName;

  NameFieldState({
    required this.isFirstNameValid,
    required this.isLastNameValid,
    required this.firstName,
    required this.lastName
  });

  factory NameFieldState.initial({required String firstName, required String lastName}) {
    return NameFieldState(
      isFirstNameValid: true,
      isLastNameValid: true,
      firstName: firstName,
      lastName: lastName
    );
  }

  NameFieldState update({
    bool? isFirstNameValid, 
    bool? isLastNameValid,
    String? firstName,
    String? lastName
  }) {
    return NameFieldState(
      isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
      isLastNameValid: isLastNameValid ?? this.isLastNameValid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName
    );
  }

  @override
  List<Object?> get props => [
    isFirstNameValid, 
    isLastNameValid,
    firstName,
    lastName
  ];
  
  @override
  String toString() => '''NameFieldState { 
    isFirstNameValid: $isFirstNameValid,
    isLastNameValid: $isLastNameValid,
    firstName: $firstName,
    lastName: $lastName
  }''';
}
