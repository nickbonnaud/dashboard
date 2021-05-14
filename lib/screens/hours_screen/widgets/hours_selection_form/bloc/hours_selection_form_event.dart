part of 'hours_selection_form_bloc.dart';

abstract class HoursSelectionFormEvent extends Equatable {
  const HoursSelectionFormEvent();

  @override
  List<Object> get props => [];
}

class GridSelectionChanged extends HoursSelectionFormEvent {
  final int indexX;
  final int indexY;
  final bool isDrag;

  const GridSelectionChanged({required this.indexX, required this.indexY, required this.isDrag});

  @override
  List<Object> get props => [indexX, indexY, isDrag];

  @override
  String toString() => 'GridSelectionChanged { indexX: $indexX, indexY: $indexY, isDrag: $isDrag }';
}

class ToggleAllHours extends HoursSelectionFormEvent {}

class Finished extends HoursSelectionFormEvent {
  final bool isFinished;

  const Finished({required this.isFinished});

  @override
  List<Object> get props => [isFinished];

  @override
  String toString() => 'Finished { isFinished: $isFinished }';
}
