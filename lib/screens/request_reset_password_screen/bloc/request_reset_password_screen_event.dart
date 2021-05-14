part of 'request_reset_password_screen_bloc.dart';

abstract class RequestResetPasswordScreenEvent extends Equatable {
  const RequestResetPasswordScreenEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RequestResetPasswordScreenEvent {
  final String email;
  
  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class Submitted extends RequestResetPasswordScreenEvent {
  final String email;
  
  const Submitted({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'Submitted { email: $email }';
}

class Reset extends RequestResetPasswordScreenEvent {}
