import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:dashboard/extensions/string_extensions.dart';

import '../status.dart';

enum PosType {
  clover,
  lightspeedRetail,
  shopify,
  square,
  vend,
  unknown
}

@immutable
class PosAccount extends Equatable {
  final String identifier;
  final PosType type;
  final bool takesTips;
  final bool allowsOpenTickets;
  final Status connectionStatus;

  PosAccount({
    required this.identifier,
    required this.type,
    required this.takesTips,
    required this.allowsOpenTickets,
    required this.connectionStatus
  });

  String get typeToString => this.type.toString().split(".").last.capitalizeFirstEach;

  PosAccount.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      type = _formatPosType(posTypeString: json['type']!),
      takesTips = json['takes_tips']!,
      allowsOpenTickets = json['allows_open_tickets']!,
      connectionStatus = Status.fromJson(json: json['status']!);

  factory PosAccount.empty() => PosAccount(
    identifier: "",
    type: PosType.unknown,
    takesTips: false,
    allowsOpenTickets: false,
    connectionStatus: Status(name: 'Unknown', code: 0)
  );

  // PosAccount update({
  //   String? identifier,
  //   PosType? type,
  //   bool? takesTips,
  //   bool? allowsOpenTickets,
  //   Status? connectionStatus
  // }) {
  //   return PosAccount(
  //     identifier: identifier ?? this.identifier, 
  //     type: type ?? this.type, 
  //     takesTips: takesTips ?? this.takesTips, 
  //     allowsOpenTickets: allowsOpenTickets ?? this.allowsOpenTickets, 
  //     connectionStatus: connectionStatus ?? this.connectionStatus
  //   );
  // }

  static PosType _formatPosType({required String posTypeString}) {
    return PosType.values.firstWhere((posType) => posType.toString().substring(posType.toString().indexOf('.') + 1).toLowerCase() == posTypeString.toLowerCase());
  }

  @override
  List<Object> get props => [
    identifier,
    type,
    takesTips,
    allowsOpenTickets,
    connectionStatus
  ];

  @override
  String toString() => '''PosAccount {
    identifier: $identifier,
    type: $type,
    takesTips: $takesTips,
    allowsOpenTickets: $allowsOpenTickets,
    connectionStatus: $connectionStatus
  }''';
}