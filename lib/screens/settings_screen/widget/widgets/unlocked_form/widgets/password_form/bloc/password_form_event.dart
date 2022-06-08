part of 'password_form_bloc.dart';

abstract class PasswordFormEvent extends Equatable {
  const PasswordFormEvent();

  @override
  List<Object> get props => [];
}

class PasswordChanged extends PasswordFormEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class PasswordConfirmationChanged extends PasswordFormEvent {
  final String passwordConfirmation;

  const PasswordConfirmationChanged({required this.passwordConfirmation});

  @override
  List<Object> get props => [passwordConfirmation];

  @override
  String toString() => 'PasswordConfirmationChanged { passwordConfirmation: $passwordConfirmation }';
}

class Submitted extends PasswordFormEvent {
  final String identifier;

  const Submitted({required this.identifier});

  @override
  List<Object> get props => [identifier];
  
  @override
  String toString() => 'Submitted { identifier: $identifier }';
}

class Reset extends PasswordFormEvent {}