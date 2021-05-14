import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/message_screen/bloc/message_history_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'message_input_event.dart';
part 'message_input_state.dart';

class MessageInputBloc extends Bloc<MessageInputEvent, MessageInputState> {
  final MessageRepository _messageRepository;
  final MessageHistoryBloc _messageHistoryBloc;
  
  MessageInputBloc({required MessageRepository messageRepository, required MessageHistoryBloc messageHistoryBloc})
    : _messageRepository = messageRepository,
      _messageHistoryBloc = messageHistoryBloc,
      super(MessageInputState.initial());

  @override
  Stream<Transition<MessageInputEvent, MessageInputState>> transformEvents(Stream<MessageInputEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !MessageChanged);
    final debounceStream = events.where((event) => event is MessageChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<MessageInputState> mapEventToState(MessageInputEvent event) async* {
    if (event is MessageChanged) {
      yield* _mapMessageChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    }
  }

  Stream<MessageInputState> _mapMessageChangedToState({required MessageChanged event}) async* {
    yield state.update(isInputValid: event.message.trim().isNotEmpty);
  }

  Stream<MessageInputState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true, errorMessage: "");
    try {
      Reply reply = await _messageRepository.addReply(messageIdentifier: event.messageIdentifier, replyBody: event.message);
      _updateMessage(reply: reply);
      yield state.update(isSubmitting: false);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error);
    }
  }

  void _updateMessage({required Reply reply}) {
    _messageHistoryBloc.add(ReplyAdded(reply: reply));
  }
}
