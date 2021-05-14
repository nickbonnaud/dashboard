import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Status extends Equatable {
  final String name;
  final int code;

  Status({required this.name, required this.code});
  
  Status.fromJson({required Map<String, dynamic> json})
    : name = json['name']!,
      code = json['code']!;

  factory Status.unknown() => Status(name: "Unknown", code: 0);

  @override
  List<Object?> get props => [name, code];
  
  @override
  String toString() => 'Status { name: $name, code: $code }';
}