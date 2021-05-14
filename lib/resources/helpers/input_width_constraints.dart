import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

const List<Condition> inputConstraintSizes = [
  Condition.equals(name: MOBILE, value: BoxConstraints(maxWidth: 600)),
  Condition.equals(name: TABLET, value: BoxConstraints(maxWidth: 700)),
  Condition.largerThan(name: TABLET, value: BoxConstraints(maxWidth: 1280)),
];

