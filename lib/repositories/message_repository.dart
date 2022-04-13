import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/message_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class MessageRepository extends BaseRepository {
  final MessageProvider _messageProvider;

  const MessageRepository({required MessageProvider messageProvider})
    : _messageProvider = messageProvider;
  
  Future<bool> checkUnreadMessages() async {
    return send(request: _messageProvider.fetch())
      .then((json) => json['unread']);
  }

  Future<PaginateDataHolder> fetchAll() async {
    PaginateDataHolder holder = await sendPaginated(request: _messageProvider.fetchPaginated());
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    PaginateDataHolder holder = await sendPaginated(request: _messageProvider.fetchPaginated(paginateUrl: url));
    return deserialize(holder: holder);
  }

  Future<Message> addMessage({required String title, required String messageBody}) async {
    Map<String, dynamic> body = {
      'title': title,
      'body': messageBody,
    };

    Map<String, dynamic> json = await send(request: _messageProvider.storeMessage(body: body));
    return deserialize(json: json);
  }
  
  Future<Reply> addReply({required String messageIdentifier, required String replyBody}) async {
    Map<String, dynamic> body = {
      'message_identifier': messageIdentifier,
      'body': replyBody,
    };

    Map<String, dynamic> json = await send(request: _messageProvider.storeReply(body: body));
    return Reply.fromJson(json: json);
  }

  Future<bool> updateMessage({required String messageIdentifier}) async {
    Map<String, dynamic> body = { 'read': true };

    await send(request: _messageProvider.updateMessage(body: body, messageIdentifier: messageIdentifier));
    return true;
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    if (holder != null) {
      return holder.update(
        data: holder.data.map((message) => Message.fromJson(json: message)).toList()
      );
    }

    return Message.fromJson(json: json!);
  }
}