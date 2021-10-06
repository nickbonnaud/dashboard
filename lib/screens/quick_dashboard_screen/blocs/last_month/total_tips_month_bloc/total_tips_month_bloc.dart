import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_tips_month_event.dart';
part 'total_tips_month_state.dart';

class TotalTipsMonthBloc extends Bloc<TotalTipsMonthEvent, TotalTipsMonthState> {
  final TransactionRepository _transactionRepository;
  
  TotalTipsMonthBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalTipsInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchTotalTipsMonth>((event, emit) => _mapFetchTotalTipsToState(emit: emit));
  }

  void _mapFetchTotalTipsToState({required Emitter<TotalTipsMonthState> emit}) async {
    emit(Loading());
    try {
      final int totalTips = await _transactionRepository.fetchTotalTipsMonth();
      emit(TotalTipsLoaded(totalTips: totalTips));
    } on ApiException catch (exception) {
      emit(FetchTotalTipsFailed(error: exception.error));
    }
  }
}
