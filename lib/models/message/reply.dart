import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Reply extends Equatable {
  final String identifier;
  final String body;
  final bool fromBusiness;
  final bool read;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Reply({
    required this.identifier,
    required this.body,
    required this.fromBusiness,
    required this.read,
    required this.createdAt, 
    required this.updatedAt
  });

  Reply.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      body = json['body']!,
      fromBusiness = json['sent_by_business']!,
      read = json['read']!,
      createdAt = DateFormatter.toDateTime(date: json['created_at']!),
      updatedAt = DateFormatter.toDateTime(date: json['updated_at']!);

  Reply update({bool? read, DateTime? updatedAt}) {
    return _copyWith(read: read, updatedAt: updatedAt);
  }
  
  Reply _copyWith({bool? read, DateTime? updatedAt}) {
    return Reply(
      identifier: this.identifier,
      body: this.body,
      fromBusiness: this.fromBusiness,
      read: read ?? this.read,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt
    );
  }

  @override
  List<Object> get props => [
    identifier,
    body,
    fromBusiness,
    read,
    createdAt,
    updatedAt
  ];

  @override
  String toString() => '''Reply {
    identifier: $identifier,
    body: $body,
    fromBusiness: $fromBusiness,
    read: $read,
    createdAt: $createdAt,
    updatedAt: $updatedAt
  }''';
}