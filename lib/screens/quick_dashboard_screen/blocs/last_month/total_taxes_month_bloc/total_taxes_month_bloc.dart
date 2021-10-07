import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'total_taxes_month_event.dart';
part 'total_taxes_month_state.dart';

class TotalTaxesMonthBloc extends Bloc<TotalTaxesMonthEvent, TotalTaxesMonthState> {
  final TransactionRepository _transactionRepository;
  
  TotalTaxesMonthBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(TotalTaxesInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchTotalTaxesMonth>((event, emit) async => await _mapFetchTotalTaxesToState(emit: emit));
  }

  Future<void> _mapFetchTotalTaxesToState({required Emitter<TotalTaxesMonthState> emit}) async {
    emit(Loading());
    try {
      final int totalTaxes = await _transactionRepository.fetchTotalTaxesMonth();
      emit(TotalTaxesLoaded(totalTaxes: totalTaxes));
    } on ApiException catch (exception) {
      emit(FetchTotalTaxesFailed(error: exception.error));
    }
  }
}
