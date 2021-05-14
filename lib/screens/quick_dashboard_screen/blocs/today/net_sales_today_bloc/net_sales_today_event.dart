part of 'net_sales_today_bloc.dart';

abstract class NetSalesTodayEvent extends Equatable {
  const NetSalesTodayEvent();

  @override
  List<Object> get props => [];
}

class FetchNetSalesToday extends NetSalesTodayEvent {}
