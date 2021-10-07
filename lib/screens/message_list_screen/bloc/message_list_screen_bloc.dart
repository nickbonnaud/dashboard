import 'package:bloc/bloc.dart';
import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'message_list_screen_event.dart';
part 'message_list_screen_state.dart';

class MessageListScreenBloc extends Bloc<MessageListScreenEvent, MessageListScreenState> {
  final MessageRepository _messageRepository;
  
  MessageListScreenBloc({required MessageRepository messageRepository}) 
    : _messageRepository = messageRepository,
      super(MessageListScreenState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<Init>((event, emit) async => await _mapInitToState(emit: emit));
    on<FetchMore>((event, emit) async => await _mapFetchMoreToState(emit: emit));
    on<MessageUpdated>((event, emit) => _mapMessageUpdatedToState(event: event, emit: emit));
  }

  Future<void> _mapInitToState({required Emitter<MessageListScreenState> emit}) async {
    emit(state.update(loading: true, errorMessage: ""));

    try {
      final PaginateDataHolder paginateData = await _messageRepository.fetchAll();
      _handleSuccess(paginateData: paginateData, emit: emit);
    } on ApiException catch (exception) {
      _handleError(error: exception.error, emit: emit);
    }
  }

  Future<void> _mapFetchMoreToState({required Emitter<MessageListScreenState> emit}) async {
    if (!state.loading && !state.paginating && !state.hasReachedEnd) {
      emit(state.update(paginating: true));
      try {
        final PaginateDataHolder paginateData = await _messageRepository.paginate(url: state.nextUrl!);
        _handleSuccess(paginateData: paginateData, emit: emit);
      } on ApiException catch (exception) {
        _handleError(error: exception.error, emit: emit);
      }
    }
  }

  void _mapMessageUpdatedToState({required MessageUpdated event, required Emitter<MessageListScreenState> emit}) {
    final List<Message> updatedMessages = state.messages
      .where((message) => message.identifier != event.message.identifier).toList()
      ..add(event.message)..sort((previousMessage, currentMessage) {
        return currentMessage.latestReply.compareTo(previousMessage.latestReply);
      });
    emit(state.update(messages: _sortMessages(messages: updatedMessages)));

    if (event.messageHistoryRead) {
      _messageRepository.updateMessage(messageIdentifier: event.message.identifier);
    }
  }

  void _handleSuccess({required PaginateDataHolder paginateData, required Emitter<MessageListScreenState> emit}) {
    emit(state.update(
      loading: false,
      paginating: false,
      messages: _sortMessages(messages: (state.messages + (paginateData.data as List<Message>))),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    ));
  }

  void _handleError({required String error, required Emitter<MessageListScreenState> emit}) {
    emit(state.update(loading: false, paginating: false, errorMessage: error)); 
  }

  List<Message> _sortMessages({required List<Message> messages}) {
    final List<Message> unreadMessages = messages.where((message) => message.hasUnread).toList();
    final List<Message> readMessages = messages.where((message) => !message.hasUnread).toList();
    return unreadMessages..addAll(readMessages);
  }
}
