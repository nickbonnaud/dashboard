import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final MessageRepository _messageRepository;

  late StreamSubscription _authStreamBlocSubscription;
  
  MessagesBloc({required MessageRepository messageRepository, required AuthenticationBloc authenticationBloc}) 
    : _messageRepository = messageRepository,
      super(MessagesState.initial()) {
        
        _eventHandler();
        
        if (authenticationBloc.isAuthenticated) {
          add(Init());
        } else {
          _authStreamBlocSubscription = authenticationBloc.stream.listen((AuthenticationState state) {
            if (state is Authenticated) {
              add(Init());
            }
          });
        }
      }

  void _eventHandler() {
    on<Init>((event, emit) => _mapInitToState(event: event, emit: emit));
  }
  
  @override
  Future<void> close() {
    _authStreamBlocSubscription.cancel();
    return super.close();
  }

  void _mapInitToState({required Init event, required Emitter<MessagesState> emit}) async {
    emit(state.update(loading: true));

    try {
      final bool hasUnread = await _messageRepository.checkUnreadMessages();
      emit(state.update(loading: false, hasUnreadMessages: hasUnread));
    } on ApiException catch (exception) {
      emit(state.update(loading: false, errorMessage: exception.error));
    }
  }
}
