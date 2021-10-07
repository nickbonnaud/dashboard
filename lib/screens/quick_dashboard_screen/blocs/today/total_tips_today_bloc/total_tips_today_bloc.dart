import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_tips_today_event.dart';
part 'total_tips_today_state.dart';

class TotalTipsTodayBloc extends Bloc<TotalTipsTodayEvent, TotalTipsTodayState> {
  final TransactionRepository _transactionRepository;
  
  TotalTipsTodayBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalTipsInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchTotalTipsToday>((event, emit) async => await _mapFetchTotalTipsToState(emit: emit));
  }

  Future<void> _mapFetchTotalTipsToState({required Emitter<TotalTipsTodayState> emit}) async {
    emit(Loading());
    try {
      final int totalTips = await _transactionRepository.fetchTotalTipsToday();
      emit(TotalTipsLoaded(totalTips: totalTips));
    } on ApiException catch (exception) {
      emit(FetchFailed(error: exception.error));
    }
  }
}
