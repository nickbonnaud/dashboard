part of 'credentials_bloc.dart';

abstract class CredentialsState extends Equatable {
  const CredentialsState();
  
  @override
  List<Object> get props => [];
}

class CredentialsInitial extends CredentialsState {}

class CredentialsLoading extends CredentialsState {}

class CredentialsLoaded extends CredentialsState {
  final Credentials credentials;

  const CredentialsLoaded({required this.credentials});

  @override
  List<Object> get props => [credentials];

  @override
  String toString() => 'CredentialsLoaded { credentials: $credentials }';
}

class FailedToFetchCredentials extends CredentialsState {
  final String error;

  const FailedToFetchCredentials({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FailedToFetchCredentials { error: $error }';
}
