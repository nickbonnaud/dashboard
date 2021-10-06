import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_refunds_month_event.dart';
part 'total_refunds_month_state.dart';

class TotalRefundsMonthBloc extends Bloc<TotalRefundsMonthEvent, TotalRefundsMonthState> {
  final RefundRepository _refundRepository;
  
  TotalRefundsMonthBloc({required RefundRepository refundRepository})
    : _refundRepository = refundRepository,
      super(TotalRefundsInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchTotalRefundsMonth>((event, emit) => _mapFetchTotalRefundsToState(emit: emit));
  }

  void _mapFetchTotalRefundsToState({required Emitter<TotalRefundsMonthState> emit}) async {
    emit(Loading());
    try {
      final int totalRefunds = await _refundRepository.fetchTotalRefundsMonth();
      emit(TotalRefundsLoaded(totalRefunds: totalRefunds));
    } on ApiException catch (exception) {
      emit(FetchTotalRefundsFailed(error: exception.error));
    }
  }
}
