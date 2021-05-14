part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class Init extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final Business business;

  const LoggedIn({required this.business});

  @override
  List<Object> get props => [business];

  @override
  String toString() => 'LoggedIn { business: $business }';
}

class LoggedOut extends AuthenticationEvent {}
