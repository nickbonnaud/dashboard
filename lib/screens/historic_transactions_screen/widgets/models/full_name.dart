import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class FullName extends Equatable {
  final String? first;
  final String? last;

  const FullName({@required this.first, @required this.last});

  @override
  List<Object?> get props => [first, last];

  @override
  String toString() => 'FullName { first: $first, last: $last }';
}