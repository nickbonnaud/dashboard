part of 'locked_form_bloc.dart';

abstract class LockedFormEvent extends Equatable {
  const LockedFormEvent();

  @override
  List<Object> get props => [];
}

class PasswordChanged extends LockedFormEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends LockedFormEvent {}

class Reset extends LockedFormEvent {}
