part of 'business_bloc.dart';

abstract class BusinessState extends Equatable {
  const BusinessState();
  
  @override
  List<Object> get props => [];
}

class BusinessInitial extends BusinessState {}

class BusinessLoading extends BusinessState {}

class BusinessLoaded extends BusinessState {
  final Business business;

  const BusinessLoaded({required this.business});

  @override
  List<Object> get props => [business];

  @override
  String toString() => 'BusinessLoaded { business: $business }';
}

class BusinessFailedToLoad extends BusinessState {
  final String error;

  const BusinessFailedToLoad({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'BusinessFailedToLoad { error: $error }';
}
