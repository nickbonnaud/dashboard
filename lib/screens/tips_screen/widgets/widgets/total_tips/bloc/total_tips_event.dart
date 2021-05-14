part of 'total_tips_bloc.dart';

abstract class TotalTipsEvent extends Equatable {
  const TotalTipsEvent();

  @override
  List<Object?> get props => [];
}

class InitTotal extends TotalTipsEvent {}

class DateRangeChanged extends TotalTipsEvent {
  final DateTimeRange? dateRange;

  const DateRangeChanged({@required this.dateRange});

  @override
  List<Object?> get props => [dateRange];

  @override
  String toString() => 'DateRangeChanged { dateRange: $dateRange }';
}
