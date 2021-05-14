part of 'id_search_field_bloc.dart';

@immutable
class IdSearchFieldState extends Equatable {
  final bool isFieldValid;
  final String currentId;
  
  const IdSearchFieldState({required this.isFieldValid, required this.currentId});

  factory IdSearchFieldState.initial() {
    return IdSearchFieldState(isFieldValid: true, currentId: "");
  }

  IdSearchFieldState update({bool? isFieldValid, String? currentId}) {
    return IdSearchFieldState(
      isFieldValid: isFieldValid ?? this.isFieldValid,
      currentId: currentId ?? this.currentId
    );
  }

  @override
  List<Object> get props => [isFieldValid, currentId];

  @override
  String toString() => 'IdSearchFieldState: { isFieldValid: $isFieldValid, currentId: $currentId }';
}
