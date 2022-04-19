import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/message_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class MessageRepository extends BaseRepository {
  final MessageProvider? _messageProvider;

  const MessageRepository({MessageProvider? messageProvider})
    : _messageProvider = messageProvider;
  
  Future<bool> checkUnreadMessages() async {
    MessageProvider messageProvider = _getMessageProvider();

    return send(request: messageProvider.fetch())
      .then((json) => json['unread']);
  }

  Future<PaginateDataHolder> fetchAll() async {
    MessageProvider messageProvider = _getMessageProvider();

    PaginateDataHolder holder = await sendPaginated(request: messageProvider.fetchPaginated());
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    MessageProvider messageProvider = _getMessageProvider();
    
    PaginateDataHolder holder = await sendPaginated(request: messageProvider.fetchPaginated(paginateUrl: url));
    return deserialize(holder: holder);
  }

  Future<Message> addMessage({required String title, required String messageBody}) async {
    Map<String, dynamic> body = {
      'title': title,
      'body': messageBody,
    };

    MessageProvider messageProvider = _getMessageProvider();
    Map<String, dynamic> json = await send(request: messageProvider.storeMessage(body: body));
    return deserialize(json: json);
  }
  
  Future<Reply> addReply({required String messageIdentifier, required String replyBody}) async {
    Map<String, dynamic> body = {
      'message_identifier': messageIdentifier,
      'body': replyBody,
    };

    MessageProvider messageProvider = _getMessageProvider();
    Map<String, dynamic> json = await send(request: messageProvider.storeReply(body: body));
    return Reply.fromJson(json: json);
  }

  Future<bool> updateMessage({required String messageIdentifier}) async {
    Map<String, dynamic> body = { 'read': true };

    MessageProvider messageProvider = _getMessageProvider();
    await send(request: messageProvider.updateMessage(body: body, messageIdentifier: messageIdentifier));
    return true;
  }

  MessageProvider _getMessageProvider() {
    return _messageProvider ?? const MessageProvider();
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