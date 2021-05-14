part of 'total_sales_today_bloc.dart';

abstract class TotalSalesTodayEvent extends Equatable {
  const TotalSalesTodayEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalSalesToday extends TotalSalesTodayEvent {}
