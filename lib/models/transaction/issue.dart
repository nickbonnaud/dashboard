import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum IssueType {
  wrongBill,
  errorInBill,
  other
}

@immutable
class Issue extends Equatable {
  static const Map<IssueType, String> _issueTypeMap = {
    IssueType.wrongBill: 'wrong_bill',
    IssueType.errorInBill: 'error_in_bill',
    IssueType.other: 'other'
  };

  final String identifier;
  final IssueType type;
  final String issue;
  final bool resolved;
  final String updatedAt;

  const Issue({required this.identifier, required this.type, required this.issue, required this.resolved, required this.updatedAt});

  Issue.fromJson({required Map<String, dynamic> json})
    : identifier =  json['identifier']!,
      type = _formatType(jsonType: json['type']!),
      issue = json['issue']!,
      resolved = json['resolved']!,
      updatedAt = json['updated_at']!;
      
  static IssueType _formatType({required String jsonType}) {
    return (_issueTypeMap.entries.firstWhere((typeMap) => typeMap.value.toLowerCase() == jsonType.toLowerCase())).key;
  }
  
  @override
  List<Object> get props => [identifier, type, issue, resolved, updatedAt];

  @override
  String toString() => 'Issue { identifier: $identifier, type: $type, issue: $issue, resolved: $resolved, updatedAt: $updatedAt }';
}