import 'package:bloc/bloc.dart';
import 'package:dashboard/models/status.dart';
import 'package:dashboard/repositories/status_repository.dart';
import 'package:dashboard/resources/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'transaction_statuses_event.dart';
part 'transaction_statuses_state.dart';

class TransactionStatusesBloc extends Bloc<TransactionStatusesEvent, TransactionStatusesState> {
  final StatusRepository _statusRepository;
  
  TransactionStatusesBloc({required StatusRepository statusRepository})
    : _statusRepository = statusRepository,
      super(TransactionStatusesState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<InitStatuses>((event, emit) => _mapInitToState(emit: emit));
  }

  void _mapInitToState({required Emitter<TransactionStatusesState> emit}) async {
    emit(state.update(loading: true));
    try {
      final List<Status> statuses = await _statusRepository.fetchTransactionStatuses();
      emit(state.update(statuses: statuses, loading: false, fetchFailed: false));
    } catch (error) {
      emit(state.update(loading: false, fetchFailed: true));
    }
  }
}
