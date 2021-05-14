part of 'login_form_bloc.dart';

abstract class LoginFormEvent extends Equatable {
  const LoginFormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginFormEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class PasswordChanged extends LoginFormEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends LoginFormEvent {
  final String email;
  final String password;

  const Submitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'Submitted { email: $email, password: $password }';
}

class Reset extends LoginFormEvent {}