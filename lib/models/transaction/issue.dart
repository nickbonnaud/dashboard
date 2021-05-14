import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum IssueType {
  wrong_bill,
  error_in_bill,
  other
}

@immutable
class Issue extends Equatable {
  final String identifier;
  final IssueType type;
  final String issue;
  final bool resolved;
  final String updatedAt;

  Issue({required this.identifier, required this.type, required this.issue, required this.resolved, required this.updatedAt});

  Issue.fromJson({required Map<String, dynamic> json})
    : identifier =  json['identifier']!,
      type = _formatType(jsonType: json['type']!),
      issue = json['issue']!,
      resolved = json['resolved']!,
      updatedAt = json['updated_at']!;
      
  static IssueType _formatType({required String jsonType}) {
    return IssueType.values.firstWhere((issueType) => issueType.toString().substring(issueType.toString().indexOf('.') + 1).toLowerCase() == jsonType.toLowerCase());
  }
  
  @override
  List<Object> get props => [identifier, type, issue, resolved, updatedAt];

  @override
  String toString() => 'Issue { identifier: $identifier, type: $type, issue: $issue, resolved: $resolved, updatedAt: $updatedAt }';
}