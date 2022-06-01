part of 'reset_password_screen_bloc.dart';

abstract class ResetPasswordScreenEvent extends Equatable {
  const ResetPasswordScreenEvent();

  @override
  List<Object> get props => [];
}

class PasswordChanged extends ResetPasswordScreenEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class PasswordConfirmationChanged extends ResetPasswordScreenEvent {
  final String passwordConfirmation;

  const PasswordConfirmationChanged({required this.passwordConfirmation});

  @override
  List<Object> get props => [passwordConfirmation];

  @override
  String toString() => 'PasswordConfirmationChanged { passwordConfirmation: $passwordConfirmation }';
}

class Submitted extends ResetPasswordScreenEvent {}

class Reset extends ResetPasswordScreenEvent {}