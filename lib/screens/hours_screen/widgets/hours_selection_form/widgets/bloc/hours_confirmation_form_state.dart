part of 'hours_confirmation_form_bloc.dart';

class HoursConfirmationFormState extends Equatable {
  final List<Hour> sunday;
  final List<Hour> monday;
  final List<Hour> tuesday;
  final List<Hour> wednesday;
  final List<Hour> thursday;
  final List<Hour> friday;
  final List<Hour> saturday;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  const HoursConfirmationFormState({
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.errorButtonControl
  });

  List<List<Hour>> get days => [
    sunday,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday
  ];

  factory HoursConfirmationFormState.initial({
    required HoursGrid hoursGrid, 
    required List<TimeOfDay> hoursList
  }) {
    return HoursConfirmationFormState(
      sunday: _setHours(day: 1, hoursGrid: hoursGrid, hoursList: hoursList),
      monday: _setHours(day: 2, hoursGrid: hoursGrid, hoursList: hoursList),
      tuesday: _setHours(day: 3, hoursGrid: hoursGrid, hoursList: hoursList),
      wednesday: _setHours(day: 4, hoursGrid: hoursGrid, hoursList: hoursList),
      thursday: _setHours(day: 5, hoursGrid: hoursGrid, hoursList: hoursList),
      friday: _setHours(day: 6, hoursGrid: hoursGrid, hoursList: hoursList),
      saturday: _setHours(day: 7, hoursGrid: hoursGrid, hoursList: hoursList),
      isSubmitting: false,
      isSuccess: false,
      errorMessage: '',
      errorButtonControl: CustomAnimationControl.stop,
    );
  }

  static List<Hour> _setHours({required int day, required HoursGrid hoursGrid, required List<TimeOfDay> hoursList}) {
    List<Hour> hours = [];
    int hour = 1;
    bool isOpen = false;

    while (hour < hoursGrid.rows) {
      if (isOpen) {
        if (!hoursGrid.operatingHoursGrid[hour][day]) {
          final Hour lastHour = hours.last;
          hours.removeAt(hours.length -1);
          hours.add(lastHour.update(end: hoursList[hour - 2]));
          isOpen = false;
        }
      } else {
        if (hoursGrid.operatingHoursGrid[hour][day]) {
          hours.add(Hour(start: hoursList[hour - 1], end: hoursList.last));
          isOpen = true;
        }
      }

      hour++;
    }
    return hours;
  }

  HoursConfirmationFormState update({
    List<Hour>? sunday,
    List<Hour>? monday,
    List<Hour>? tuesday,
    List<Hour>? wednesday,
    List<Hour>? thursday,
    List<Hour>? friday,
    List<Hour>? saturday,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return HoursConfirmationFormState(
      sunday: sunday ?? this.sunday,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl,
    );
  }

  @override
  List<Object?> get props => [
    sunday,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    isSubmitting,
    isSuccess,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() {
    return '''HoursConfirmationFormState {
      sunday: $sunday,
      monday: $monday,
      tuesday: $tuesday,
      wednesday: $wednesday,
      thursday: $thursday,
      friday: $friday,
      saturday: $saturday,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: $errorMessage,
      errorButtonControl: $errorButtonControl
    }''';
  }
}
