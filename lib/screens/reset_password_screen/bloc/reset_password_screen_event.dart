part of 'reset_password_screen_bloc.dart';

abstract class ResetPasswordScreenEvent extends Equatable {
  const ResetPasswordScreenEvent();

  @override
  List<Object> get props => [];
}

class PasswordChanged extends ResetPasswordScreenEvent {
  final String password;
  final String passwordConfirmation;

  const PasswordChanged({required this.password, required this.passwordConfirmation});

  @override
  List<Object> get props => [password, passwordConfirmation];

  @override
  String toString() => 'PasswordChanged { password: $password, passwordConfirmation: $passwordConfirmation }';
}

class PasswordConfirmationChanged extends ResetPasswordScreenEvent {
  final String passwordConfirmation;
  final String password;

  const PasswordConfirmationChanged({required this.passwordConfirmation, required this.password});

  @override
  List<Object> get props => [passwordConfirmation, password];

  @override
  String toString() => 'PasswordConfirmationChanged { passwordConfirmation: $passwordConfirmation, password: $password }';
}

class Submitted extends ResetPasswordScreenEvent {
  final String password;
  final String passwordConfirmation;

  const Submitted({required this.password, required this.passwordConfirmation});

  @override
  List<Object> get props => [password, passwordConfirmation];
  
  @override
  String toString() => '''Submitted {
    password: $password,
    passwordConfirmation: $passwordConfirmation 
  }''';
}

class Reset extends ResetPasswordScreenEvent {}