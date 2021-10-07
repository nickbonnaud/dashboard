import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_refunds_today_event.dart';
part 'total_refunds_today_state.dart';

class TotalRefundsTodayBloc extends Bloc<TotalRefundsTodayEvent, TotalRefundsTodayState> {
  final RefundRepository _refundRepository;
  
  TotalRefundsTodayBloc({required RefundRepository refundRepository})
    : _refundRepository = refundRepository,
      super(TotalRefundsInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchTotalRefundsToday>((event, emit) async => await _mapFetchTotalRefundsToState(emit: emit));
  }

  Future<void> _mapFetchTotalRefundsToState({required Emitter<TotalRefundsTodayState> emit}) async {
    emit(Loading());

    try {
      final int totalRefunds = await _refundRepository.fetchTotalRefundsToday();
      emit(TotalRefundsLoaded(totalRefunds: totalRefunds));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }
}
