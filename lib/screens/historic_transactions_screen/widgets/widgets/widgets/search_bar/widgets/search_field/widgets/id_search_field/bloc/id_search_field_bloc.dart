import 'package:bloc/bloc.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/bloc/transactions_list_bloc.dart';
import 'package:equatable/equatable.dart';

part 'id_search_field_event.dart';
part 'id_search_field_state.dart';

class IdSearchFieldBloc extends Bloc<IdSearchFieldEvent, IdSearchFieldState> {
  final TransactionsListBloc _transactionsListBloc;
  final FilterButtonCubit _filterButtonCubit;
  
  IdSearchFieldBloc({required TransactionsListBloc transactionsListBloc, required FilterButtonCubit filterButtonCubit}) 
    : _transactionsListBloc = transactionsListBloc,
      _filterButtonCubit = filterButtonCubit,
      super(IdSearchFieldState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<FieldChanged>((event, emit) => _mapFieldChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: const Duration(seconds: 1)));
  }

  void _mapFieldChangedToState({required FieldChanged event, required Emitter<IdSearchFieldState> emit}) {
    final bool isValidId = Validators.isValidUUID(uuid: event.id);
    final String previousId = state.currentId;
    
    emit(state.update(isFieldValid: isValidId, currentId: event.id));

    if (isValidId && previousId != event.id) {
      _transactionsListBloc.add(
        _filterButtonCubit.state == FilterType.customerId
          ? FetchByCustomerId(customerId: event.id)
          : FetchByTransactionId(transactionId: event.id)
      );
    }
  }
}
