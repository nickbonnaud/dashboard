part of 'register_form_bloc.dart';

abstract class RegisterFormEvent extends Equatable {
  const RegisterFormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RegisterFormEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class PasswordChanged extends RegisterFormEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class PasswordConfirmationChanged extends RegisterFormEvent {
  final String passwordConfirmation;

  const PasswordConfirmationChanged({required this.passwordConfirmation});

  @override
  List<Object> get props => [passwordConfirmation];

  @override
  String toString() => 'PasswordConfirmationChanged { passwordConfirmation: $passwordConfirmation }';
}

class Submitted extends RegisterFormEvent {}

class Reset extends RegisterFormEvent {}