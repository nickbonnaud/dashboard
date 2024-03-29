import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Photo extends Equatable {
  final String name;
  final String smallUrl;
  final String largeUrl;

  const Photo({required this.name, required this.smallUrl, required this.largeUrl});

  Photo.fromJson({required Map<String, dynamic> json})
    : name = json['name']!,
      smallUrl = json['small_url']!,
      largeUrl = json['large_url']!;

  factory Photo.empty() => const Photo(
    name: "",
    smallUrl: "",
    largeUrl: ""
  );

  @override
  List<Object> get props => [name, smallUrl, largeUrl];

  @override
  String toString() => 'Photo { name: $name, smallUrl: $smallUrl, largeUrl: $largeUrl }';
}