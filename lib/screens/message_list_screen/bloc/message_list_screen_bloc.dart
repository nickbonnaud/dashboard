import 'dart:async';

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
      super(MessageListScreenState.initial());

  @override
  Stream<MessageListScreenState> mapEventToState(MessageListScreenEvent event) async* {
    if (event is Init) {
      yield* _mapInitToState();
    } else if (event is FetchMore) {
      yield* _mapFetchMoreToState();
    } else if (event is MessageUpdated) {
      yield* _mapMessageUpdatedToState(event: event);
    }
  }

  Stream<MessageListScreenState> _mapInitToState() async* {
    yield state.update(loading: true, errorMessage: "");

    try {
      final PaginateDataHolder paginateData = await _messageRepository.fetchAll();
      yield* _handleSuccess(paginateData: paginateData);
    } on ApiException catch (exception) {
      yield* _handleError(error: exception.error);
    }
  }

  Stream<MessageListScreenState> _mapFetchMoreToState() async* {
    if (!state.loading && !state.paginating && !state.hasReachedEnd) {
      yield state.update(paginating: true);
      try {
        final PaginateDataHolder paginateData = await _messageRepository.paginate(url: state.nextUrl!);
        yield* _handleSuccess(paginateData: paginateData);
      } on ApiException catch (exception) {
        yield* _handleError(error: exception.error);
      }
    }
  }

  Stream<MessageListScreenState> _mapMessageUpdatedToState({required MessageUpdated event}) async* {
    final List<Message> updatedMessages = state.messages
      .where((message) => message.identifier != event.message.identifier).toList()
      ..add(event.message)..sort((previousMessage, currentMessage) {
        return currentMessage.latestReply.compareTo(previousMessage.latestReply);
      });
    yield state.update(messages: _sortMessages(messages: updatedMessages));

    if (event.messageHistoryRead) {
      _messageRepository.updateMessage(messageIdentifier: event.message.identifier);
    }
  }

  Stream<MessageListScreenState> _handleSuccess({required PaginateDataHolder paginateData}) async* {
    yield state.update(
      loading: false,
      paginating: false,
      messages: _sortMessages(messages: (state.messages + (paginateData.data as List<Message>))),
      nextUrl: paginateData.next,
      hasReachedEnd: paginateData.next == null
    );
  }

  Stream<MessageListScreenState> _handleError({required String error}) async* {
    yield state.update(loading: false, paginating: false, errorMessage: error); 
  }

  List<Message> _sortMessages({required List<Message> messages}) {
    final List<Message> unreadMessages = messages.where((message) => message.hasUnread).toList();
    final List<Message> readMessages = messages.where((message) => !message.hasUnread).toList();
    return unreadMessages..addAll(readMessages);
  }
}
