part of 'id_search_field_bloc.dart';

abstract class IdSearchFieldEvent extends Equatable {
  const IdSearchFieldEvent();

  @override
  List<Object> get props => [];
}

class FieldChanged extends IdSearchFieldEvent {
  final String id;

  const FieldChanged({required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'FieldChanged { id: $id }';
}
