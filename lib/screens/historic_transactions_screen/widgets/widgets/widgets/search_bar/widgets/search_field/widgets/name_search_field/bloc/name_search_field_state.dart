part of 'name_search_field_bloc.dart';

@immutable
class NameSearchFieldState extends Equatable {
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final String firstName;
  final String lastName;

  NameSearchFieldState({
    required this.isFirstNameValid,
    required this.isLastNameValid,
    required this.firstName,
    required this.lastName
  });

  factory NameSearchFieldState.initial() {
    return NameSearchFieldState(
      isFirstNameValid: true,
      isLastNameValid: true,
      firstName: "",
      lastName: ""
    );
  }

  NameSearchFieldState update({
    bool? isFirstNameValid, 
    bool? isLastNameValid,
    String? firstName,
    String? lastName
  }) {
    return NameSearchFieldState(
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
  String toString() => '''NameSearchFieldState { 
    isFirstNameValid: $isFirstNameValid,
    isLastNameValid: $isLastNameValid,
    firstName: $firstName,
    lastName: $lastName
  }''';
}
