part of 'hours_selection_form_bloc.dart';

@immutable
class HoursSelectionFormState extends Equatable {
  final HoursGrid operatingHoursGrid;
  final bool isFinished;

  const HoursSelectionFormState({
    required this.operatingHoursGrid, 
    required this.isFinished,
  });

  factory HoursSelectionFormState.initial({required Hour operatingHoursRange}) {
    return HoursSelectionFormState(
      operatingHoursGrid: HoursGrid.initial(operatingHoursRange: operatingHoursRange),
      isFinished: false,
    );
  }

  HoursSelectionFormState update({
    HoursGrid? operatingHoursGrid,
    bool? isFinished,
  }) {
    return _copyWith(
      operatingHoursGrid: operatingHoursGrid,
      isFinished: isFinished,
    );
  }

  HoursSelectionFormState _copyWith({
    HoursGrid? operatingHoursGrid,
    bool? isFinished,
  }) {
    return HoursSelectionFormState(
      operatingHoursGrid: operatingHoursGrid ?? this.operatingHoursGrid,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  @override
  List<Object?> get props => [operatingHoursGrid, isFinished];
  
  @override
    String toString() {
      return '''HoursSelectionFormState {
        operatingHoursGrid: $operatingHoursGrid,
        isFinished: $isFinished,
      }''';
    }
}
