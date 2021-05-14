import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import './reply.dart';

@immutable
class Message extends Equatable {
  final String identifier;
  final String title;
  final String body;
  final bool fromBusiness;
  final bool read;
  final bool unreadReply;
  final DateTime latestReply;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Reply> replies;

  const Message({
    required this.identifier,
    required this.title,
    required this.body,
    required this.fromBusiness,
    required this.read,
    required this.unreadReply,
    required this.latestReply,
    required this.createdAt,
    required this.updatedAt,
    required this.replies
  });

  bool get hasUnread => (!fromBusiness && !read ) || _hasUnreadReply;
  bool get _hasUnreadReply => replies.any((reply) => !reply.fromBusiness && !reply.read);
  
  Message.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      title = json['title']!,
      body = json['body']!,
      fromBusiness = json['sent_by_business']!,
      read = json['read'],
      unreadReply = json['unread_reply']!,
      createdAt = DateFormatter.toDateTime(date: json['created_at']!),
      updatedAt = DateFormatter.toDateTime(date: json['updated_at']!),
      latestReply = DateFormatter.toDateTime(date: json['latest_reply']!),
      replies = (json['replies']! as List)
        .map((jsonReplies) => Reply.fromJson(json: jsonReplies))
        .toList();

  Message update({
    bool? read,
    bool? unreadReply,
    DateTime? latestReply,
    List<Reply>? replies
  }) {
    return _copyWith(
      read: read,
      unreadReply: unreadReply,
      latestReply: latestReply,
      replies: replies
    );
  }
  
  Message _copyWith({
    bool? read,
    bool? unreadReply,
    DateTime? latestReply,
    List<Reply>? replies
  }) {
    return Message(
      identifier: this.identifier,
      title: this.title,
      body: this.body,
      fromBusiness: this.fromBusiness,
      read: read ?? this.read,
      unreadReply: unreadReply ?? this.unreadReply,
      latestReply: latestReply ?? this.latestReply,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      replies: replies ?? this.replies
    );
  }

  @override
  List<Object> get props => [
    identifier,
    title,
    body,
    fromBusiness,
    read,
    unreadReply,
    latestReply,
    createdAt,
    updatedAt,
    replies
  ];

  @override
  String toString() => '''Message {
    identifier: $identifier,
    title: $title,
    body: $body,
    fromBusiness: $fromBusiness,
    read: $read,
    unreadReply: $unreadReply,
    latestReply: $latestReply,
    createdAt: $createdAt,
    updatedAt: $updatedAt,
    replies: $replies
  }''';
}