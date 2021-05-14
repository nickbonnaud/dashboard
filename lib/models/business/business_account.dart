import 'package:equatable/equatable.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:meta/meta.dart';

import 'address.dart';

enum EntityType {
  soleProprietorship,
  corporation,
  llc,
  partnership,
  unknown
}

@immutable
class BusinessAccount extends Equatable {
  final String identifier;
  final String? ein;
  final String businessName;
  final Address address;
  final EntityType entityType;

  BusinessAccount({
    required this.identifier,
    required this.businessName,
    required this.address,
    required this.entityType,
    this.ein
  });
  
  BusinessAccount.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      ein = json['ein'],
      businessName = json['business_name']!,
      address = Address.fromJson(json: json['address']!),
      entityType = _stringToEntityType(entityTypeString: json['entity_type']!);

  BusinessAccount.fromMaps({required PlaceDetails details})
    : identifier = "",
      ein = null,
      businessName = details.name,
      address = Address(
        address: "${_fromPlaceDetails(details: details, type: 'street_number')} ${_fromPlaceDetails(details: details, type: 'route')}",
        addressSecondary: _fromPlaceDetails(details: details, type: 'floor'),
        city: _fromPlaceDetails(details: details, type: 'locality'),
        state: _fromPlaceDetails(details: details, type: 'administrative_area_level_1', isShort: true),
        zip: _fromPlaceDetails(details: details, type: 'postal_code')
      ),
      entityType = EntityType.unknown;

  factory BusinessAccount.empty() => BusinessAccount(
    identifier: "",
    businessName: "",
    address: Address.empty(),
    entityType: EntityType.unknown
  );
  
  static EntityType _stringToEntityType({required String entityTypeString}) {
    return EntityType.values.firstWhere((entityType) {
      return entityType.toString().substring(entityType.toString().indexOf('.') + 1).toLowerCase() == entityTypeString.toLowerCase();
    });
  }

  static String entityTypeToString({required EntityType entityType}) {
    return entityType.toString().substring(entityType.toString().indexOf('.') + 1).toLowerCase();
  }

  static String _fromPlaceDetails({required PlaceDetails details, required String type, bool isShort = false}) {
    AddressComponent? component = details.addressComponents.firstWhere(
      (component) => component.types.contains(type),
      orElse: () => AddressComponent(types: [], longName: "", shortName: "")
    );
    return component.shortName.isNotEmpty && component.longName.isNotEmpty
      ? isShort ? component.shortName : component.longName
      : "";
  }

  @override
  List<Object?> get props => [identifier, ein, businessName, address, entityType];

  @override
  String toString() => '''BusinessAccount {
    identifier: $identifier,
    ein: $ein,
    businessName: $businessName,
    address: $address,
    entityType: $entityType
  }''';
}