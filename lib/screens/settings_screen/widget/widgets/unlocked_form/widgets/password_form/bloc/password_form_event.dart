part of 'password_form_bloc.dart';

abstract class PasswordFormEvent extends Equatable {
  const PasswordFormEvent();

  @override
  List<Object> get props => [];
}

class PasswordChanged extends PasswordFormEvent {
  final String password;
  final String passwordConfirmation;

  const PasswordChanged({required this.password, required this.passwordConfirmation});

  @override
  List<Object> get props => [password, passwordConfirmation];

  @override
  String toString() => 'PasswordChanged { password: $password, passwordConfirmation: $passwordConfirmation }';
}

class PasswordConfirmationChanged extends PasswordFormEvent {
  final String password;
  final String passwordConfirmation;

  const PasswordConfirmationChanged({required this.password, required this.passwordConfirmation});

  @override
  List<Object> get props => [password, passwordConfirmation];

  @override
  String toString() => 'PasswordConfirmationChanged { password: $password, passwordConfirmation: $passwordConfirmation }';
}

class Submitted extends PasswordFormEvent {
  final String password;
  final String passwordConfirmation;
  final String identifier;

  const Submitted({required this.password, required this.passwordConfirmation, required this.identifier});

  @override
  List<Object> get props => [password, passwordConfirmation, identifier];
  
  @override
  String toString() => 'Submitted { password: $password, passwordConfirmation: $passwordConfirmation, identifier: $identifier }';
}

class Reset extends PasswordFormEvent {}