import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Token extends Equatable {
  final String value;
  final DateTime expiry;

  Token({required this.value, required this.expiry});

  Token.fromJson({required Map<String, dynamic> json})
    : value = json['value']!,
      expiry = DateTime.parse(json['expiry']!);

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'expiry': expiry.toIso8601String()
    };
  }

  @override
  List<Object> get props => [value, expiry];

  @override
  String toString() => 'Token { value: $value, expiry: $expiry }';
}