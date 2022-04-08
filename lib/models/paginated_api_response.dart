import 'package:meta/meta.dart';

@immutable
class PaginatedApiResponse {
  final List<Map<String, dynamic>> body;
  final String error;
  final bool isOK;
  final String? next;

  const PaginatedApiResponse({
    required this.body,
    this.error = "",
    required this.isOK,
    this.next
  });

  @override
  String toString() => '''PaginatedApiResponse {
    body: $body,
    error: $error,
    isOk: $isOK,
    next: $next
  }''';
}