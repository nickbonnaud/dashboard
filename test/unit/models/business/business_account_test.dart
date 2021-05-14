import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/resources/http/mock_responses.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_webservice/places.dart';

void main() {
  
  group("Business Account Tests", () {

    test("A Business Account can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateBusinessAccount();
      var businessAccount = BusinessAccount.fromJson(json: json);
      expect(businessAccount is BusinessAccount, true);
    });

    test("A Business Account can create empty placeholder", () {
      var businessAccount = BusinessAccount.empty();
      expect(businessAccount is BusinessAccount, true);
    });

    test("A Business Account can deserialize from Maps", () {
      PlaceDetails details = PlaceDetails(
        name: faker.company.name(),
        adrAddress: faker.address.streetAddress(), 
        placeId: faker.guid.guid(), 
        utcOffset: 2,
        addressComponents: [
          AddressComponent(types: ['street_number'], longName: faker.address.streetAddress(), shortName: faker.address.streetAddress()),
          AddressComponent(types: ['floor'], longName: faker.address.streetSuffix(), shortName: faker.address.streetSuffix()),
          AddressComponent(types: ['locality'], longName: faker.address.city(), shortName: faker.address.city()),
          AddressComponent(types: ['administrative_area_level_1'], longName: 'North Carolina', shortName: 'NC'),
          AddressComponent(types: ['postal_code'], longName: faker.address.zipCode(), shortName: faker.address.zipCode())
        ]
      );

      var businessAccount = BusinessAccount.fromMaps(details: details);
      expect(businessAccount is BusinessAccount, true);

      details = PlaceDetails(
        name: faker.company.name(),
        adrAddress: faker.address.streetAddress(), 
        placeId: faker.guid.guid(), 
        utcOffset: 2,
        addressComponents: [
          AddressComponent(types: ['street_number'], longName: faker.address.streetAddress(), shortName: faker.address.streetAddress()),
          AddressComponent(types: ['locality'], longName: faker.address.city(), shortName: faker.address.city()),
          AddressComponent(types: ['administrative_area_level_1'], longName: 'North Carolina', shortName: 'NC'),
          AddressComponent(types: ['postal_code'], longName: faker.address.zipCode(), shortName: faker.address.zipCode())
        ]
      );

      businessAccount = BusinessAccount.fromMaps(details: details);
      expect(businessAccount is BusinessAccount, true);
    });

    test("A business Account converts string entity type to Entity Type", () {
      final Map<String, dynamic> json = MockResponses.generateBusinessAccount();
      var businessAccount = BusinessAccount.fromJson(json: json);
      expect(businessAccount.entityType is EntityType, true);
    });

    test("A Bank Account converts Entity Type to string", () {
      final Map<String, dynamic> json = MockResponses.generateBusinessAccount();
      var businessAccount = BusinessAccount.fromJson(json: json);
      expect(businessAccount.entityType is EntityType, true);
      expect(BusinessAccount.entityTypeToString(entityType: businessAccount.entityType) is String, true);
    });
  });
}