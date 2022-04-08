import 'package:flutter/material.dart';

@immutable
class Credentials {
  final String? googleKey;

  const Credentials({this.googleKey});

  Credentials.fromJson({required Map<String, dynamic> json})
    : googleKey = json['google_key'];

  @override
  String toString() => 'Credentials { googleKey: $googleKey }';
}