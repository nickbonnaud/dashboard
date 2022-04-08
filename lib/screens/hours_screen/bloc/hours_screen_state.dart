part of 'hours_screen_bloc.dart';

@immutable
class HoursScreenState extends Equatable {
  final TimeOfDay? earliestStart;
  final TimeOfDay? latestEnd;

  const HoursScreenState({
    this.earliestStart,
    this.latestEnd
  });

  factory HoursScreenState.initial() {
    return const HoursScreenState(
      earliestStart: null,
      latestEnd: null
    );
  }

  HoursScreenState update({
    TimeOfDay? earliestStart,
    TimeOfDay? latestEnd
  }) {
    return HoursScreenState(
      earliestStart: earliestStart ?? this.earliestStart,
      latestEnd: latestEnd ?? this.latestEnd
    );
  }

  @override
  List<Object?> get props => [earliestStart, latestEnd];
  
  @override
  String toString() {
    return '''HoursScreenState {
      earliesStart: $earliestStart,
      latestEnd: $latestEnd
    }''';
  }
}
