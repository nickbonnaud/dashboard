part of 'name_search_field_bloc.dart';

abstract class NameSearchFieldEvent extends Equatable {
  const NameSearchFieldEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends NameSearchFieldEvent {
  final String firstName;
  final String lastName;

  const NameChanged({required this.firstName, required this.lastName});

  @override
  List<Object> get props => [firstName, lastName];

  @override
  String toString() => 'NameChanged { firstName: $firstName, lastName: $lastName }';
}

class Reset extends NameSearchFieldEvent {}
