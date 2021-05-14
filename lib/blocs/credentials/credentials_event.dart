part of 'credentials_bloc.dart';

abstract class CredentialsEvent extends Equatable {
  const CredentialsEvent();

  @override
  List<Object> get props => [];
}

class Init extends CredentialsEvent {}