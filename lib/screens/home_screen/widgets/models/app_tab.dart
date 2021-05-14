import 'package:flutter/material.dart';

class AppTab {
  final Widget child;
  final String title;
  final IconData icon;

  AppTab({required this.child, required this.title, required this.icon});

  @override
  String toString() => 'Tab { child: $child, title: $title, icon: $icon }';
}