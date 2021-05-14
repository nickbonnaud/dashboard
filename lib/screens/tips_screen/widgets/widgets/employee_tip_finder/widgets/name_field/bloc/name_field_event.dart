part of 'name_field_bloc.dart';

abstract class NameFieldEvent extends Equatable {
  const NameFieldEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends NameFieldEvent {
  final String firstName;
  final String lastName;

  const NameChanged({required this.firstName, required this.lastName});

  @override
  List<Object> get props => [firstName, lastName];

  @override
  String toString() => 'NameChanged { firstName: $firstName, lastName: $lastName }';
}
