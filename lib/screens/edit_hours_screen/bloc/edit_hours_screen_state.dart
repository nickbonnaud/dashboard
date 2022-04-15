part of 'edit_hours_screen_bloc.dart';

@immutable
class EditHoursScreenState extends Equatable {
  final List<Hour> sunday;
  final List<Hour> monday;
  final List<Hour> tuesday;
  final List<Hour> wednesday;
  final List<Hour> thursday;
  final List<Hour> friday;
  final List<Hour> saturday;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  const EditHoursScreenState({
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
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

  factory EditHoursScreenState.initial({required Hours hours}) {
    return EditHoursScreenState(
      sunday: stringToHoursList(day: hours.sunday),
      monday: stringToHoursList(day: hours.monday),
      tuesday: stringToHoursList(day: hours.tuesday),
      wednesday: stringToHoursList(day: hours.wednesday),
      thursday: stringToHoursList(day: hours.thursday),
      friday: stringToHoursList(day: hours.friday),
      saturday: stringToHoursList(day: hours.saturday),
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      errorMessage: "",
      errorButtonControl: CustomAnimationControl.stop,
    );
  }

  EditHoursScreenState update({
    List<Hour>? sunday,
    List<Hour>? monday,
    List<Hour>? tuesday,
    List<Hour>? wednesday,
    List<Hour>? thursday,
    List<Hour>? friday,
    List<Hour>? saturday,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return EditHoursScreenState(
      sunday: sunday ?? this.sunday,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl,
    );
  }

  static List<Hour> stringToHoursList({required String day}) {
    if (day.toLowerCase() == 'closed') return [];
    return day.split(" || ").map((hours) {
      final List<String> hoursSplit = hours.split(" - ");
      return Hour(start: stringToTimeOfDay(time: hoursSplit.first), end: stringToTimeOfDay(time: hoursSplit.last));
    }).toList();
  }

  static TimeOfDay stringToTimeOfDay({required String time}) {
    final DateTime formattedTime = DateFormat.jm().parse(time);
    return TimeOfDay(hour: formattedTime.hour, minute: formattedTime.minute);
  }

  @override
  List<Object> get props => [
    sunday,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    isSubmitting,
    isSuccess,
    isFailure,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() {
    return '''EditHoursScreenState {
      sunday: $sunday,
      monday: $monday,
      tuesday: $tuesday,
      wednesday: $wednesday,
      thursday: $thursday,
      friday: $friday,
      saturday: $saturday,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      errorMessage: $errorMessage,
      errorButtonControl: $errorButtonControl
    }''';
  }
}
