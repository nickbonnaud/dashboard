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

  @override
  Stream<MessagesState> mapEventToState(MessagesEvent event) async* {
    if (event is Init) {
      yield* _mapInitToState(event: event);
    }
  }

   @override
  Future<void> close() {
    _authStreamBlocSubscription.cancel();
    return super.close();
  }

  Stream<MessagesState> _mapInitToState({required Init event}) async* {
    yield state.update(loading: true);

    try {
      final bool hasUnread = await _messageRepository.checkUnreadMessages();
      yield state.update(loading: false, hasUnreadMessages: hasUnread);
    } on ApiException catch (exception) {
      yield state.update(loading: false, errorMessage: exception.error);
    }
  }
}
