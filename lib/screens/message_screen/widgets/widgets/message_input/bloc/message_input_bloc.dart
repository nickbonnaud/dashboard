import 'package:bloc/bloc.dart';
import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/screens/message_screen/bloc/message_history_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'message_input_event.dart';
part 'message_input_state.dart';

class MessageInputBloc extends Bloc<MessageInputEvent, MessageInputState> {
  final MessageRepository _messageRepository;
  final MessageHistoryBloc _messageHistoryBloc;
  
  MessageInputBloc({required MessageRepository messageRepository, required MessageHistoryBloc messageHistoryBloc})
    : _messageRepository = messageRepository,
      _messageHistoryBloc = messageHistoryBloc,
      super(MessageInputState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<MessageChanged>((event, emit) => _mapMessageChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: Duration(milliseconds: 300)));
    on<Submitted>((event, emit) => _mapSubmittedToState(event: event, emit: emit));
  }

  void _mapMessageChangedToState({required MessageChanged event, required Emitter<MessageInputState> emit}) async {
    emit(state.update(isInputValid: event.message.trim().isNotEmpty));
  }

  void _mapSubmittedToState({required Submitted event, required Emitter<MessageInputState> emit}) async {
    emit(state.update(isSubmitting: true, errorMessage: ""));
    try {
      Reply reply = await _messageRepository.addReply(messageIdentifier: event.messageIdentifier, replyBody: event.message);
      _updateMessage(reply: reply);
      emit(state.update(isSubmitting: false));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  void _updateMessage({required Reply reply}) {
    _messageHistoryBloc.add(ReplyAdded(reply: reply));
  }
}
