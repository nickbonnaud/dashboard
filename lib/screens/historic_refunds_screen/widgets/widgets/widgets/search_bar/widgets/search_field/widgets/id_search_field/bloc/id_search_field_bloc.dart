import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/bloc/refunds_list_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'id_search_field_event.dart';
part 'id_search_field_state.dart';

class IdSearchFieldBloc extends Bloc<IdSearchFieldEvent, IdSearchFieldState> {
  final RefundsListBloc _refundsListBloc;
  final FilterButtonCubit _filterButtonCubit; 
  
  IdSearchFieldBloc({required RefundsListBloc refundsListBloc, required FilterButtonCubit filterButtonCubit})
    : _refundsListBloc = refundsListBloc,
      _filterButtonCubit = filterButtonCubit,
      super(IdSearchFieldState.initial());

  @override
  Stream<Transition<IdSearchFieldEvent, IdSearchFieldState>> transformEvents(Stream<IdSearchFieldEvent> events, transitionFn) {
    return super.transformEvents(events.debounceTime(Duration(seconds: 1)), transitionFn);
  }
  
  @override
  Stream<IdSearchFieldState> mapEventToState(IdSearchFieldEvent event) async* {
    if (event is FieldChanged) {
      yield* _mapFieldChangedToState(event: event);
    }
  }

  Stream<IdSearchFieldState> _mapFieldChangedToState({required FieldChanged event}) async* {
    final bool isValidId = Validators.isValidUUID(uuid: event.id);
    final String previousId = state.currentId;

    yield state.update(isFieldValid: isValidId, currentId: event.id);
    if (isValidId && previousId != event.id) {
      _refundsListBloc.add(
        _filterButtonCubit.state == FilterType.refundId
          ? FetchByRefundId(refundId: event.id)
          : _filterButtonCubit.state == FilterType.transactionId
            ? FetchByTransactionId(transactionId: event.id)
            : FetchByCustomerId(customerId: event.id)
      );
    }
  }
}
