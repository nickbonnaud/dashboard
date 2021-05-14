import 'package:dashboard/resources/helpers/validators.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Validators Tests", () {

    test("Email Validator checks email for validity", () {
      String validEmail = "realEmail@gmail.com";
      String invalidEmail = "bad!email@w=2.ja^";
      expect(Validators.isValidEmail(email: validEmail), true);
      expect(Validators.isValidEmail(email: invalidEmail), false);
    });

    test("Password Validator checks password validity", () {
      String validPassword = "bN!sg7y84&bDs";
      String emptyPassword = "";
      String noUpperCase = "bn!sg7y84&bds";
      String noLowerCase = "BN!SG7Y84&BDS";
      String noDigits = "bN!sgy&bDs";
      String noSpecialCharacters = "bNsg7y84bDs";
      String notMinLength = "Bn7#";

      expect(Validators.isValidPassword(password: validPassword), true);
      expect(Validators.isValidPassword(password: emptyPassword), false);
      expect(Validators.isValidPassword(password: noUpperCase), false);
      expect(Validators.isValidPassword(password: noLowerCase), false);
      expect(Validators.isValidPassword(password: noDigits), false);
      expect(Validators.isValidPassword(password: noSpecialCharacters), false);
      expect(Validators.isValidPassword(password: notMinLength), false);
    });

    test("Password Confirmation Validator checks confirmation validity", () {
      String password = faker.internet.password();
      expect(Validators.isPasswordConfirmationValid(password: password, passwordConfirmation: password), true);
      expect(Validators.isPasswordConfirmationValid(password: password, passwordConfirmation: "s${password}w@X"), false);
    });

    test("Business Name validator checks name validity", () {
      String validName = faker.company.name();
      String invalidName = "a";
      expect(Validators.isValidBusinessName(name: validName), true);
      expect(Validators.isValidBusinessName(name: invalidName), false);
    });

    test("First Name validator checks name validity", () {
      String validName = faker.person.firstName();
      String invalidName = "s";
      expect(Validators.isValidFirstName(name: validName), true);
      expect(Validators.isValidFirstName(name: invalidName), false);
    });

    test("Last Name validator checks name validity", () {
      String validName = faker.person.lastName();
      String invalidName = "s";
      expect(Validators.isValidFirstName(name: validName), true);
      expect(Validators.isValidFirstName(name: invalidName), false);
    });

    test("Phone validator checks phone number validity", () {
      String validPhone = "1234567892";
      String invalidLong = "9108532465122";
      String invalidShort = "214343";
      String invalidCharacters = "1!34H6789s";
      expect(Validators.isValidPhone(phone: validPhone), true);
      expect(Validators.isValidPhone(phone: invalidLong), false);
      expect(Validators.isValidPhone(phone: invalidShort), false);
      expect(Validators.isValidPhone(phone: invalidCharacters), false);
    });

    test("Business description validator checks description validity", () {
      String valid = faker.randomGenerator.string(100, min: 50);
      String invalid = faker.randomGenerator.string(49);
      expect(Validators.isValidBusinessDescription(description: valid), true);
      expect(Validators.isValidBusinessDescription(description: invalid), false);
    });

    test("Address validator checks address validity", () {
      String valid = "shf3";
      String invalid = "sw";
      expect(Validators.isValidAddress(address: valid), true);
      expect(Validators.isValidAddress(address: invalid), false);
    });

    test("Address Secondary validator checks secondary address validity", () {
      String validEmpty = "";
      String valid = "sd";
      String invalid = "s";
      expect(Validators.isValidAddressSecondary(address: validEmpty), true);
      expect(Validators.isValidAddressSecondary(address: valid), true);
      expect(Validators.isValidAddressSecondary(address: invalid), false);
    });

    test("City validator checks city name validity", () {
      String valid = "Hkla-ssns.stra";
      String invalid = "sw";
      String invalidFormat = "fn?jd_a!";
      expect(Validators.isValidCity(city: valid), true);
      expect(Validators.isValidCity(city: invalid), false);
      expect(Validators.isValidCity(city: invalidFormat), false);
    });

    test("Zip validator checks zip validity", () {
      String valid = "12345";
      String invalidShort = "123";
      String invalidLong = "1234567";
      String invalidFormat = "1!3l ";
      expect(Validators.isValidZip(zip: valid), true);
      expect(Validators.isValidZip(zip: invalidShort), false);
      expect(Validators.isValidZip(zip: invalidLong), false);
      expect(Validators.isValidZip(zip: invalidFormat), false);
    });

    test("EIN validator checks EIN validity", () {
      String valid = "12-3456789";
      String invalidShort = "12-345678";
      String invalidLong = "12-34567891";
      String invalidFormat = "1!3ldgbf4 ";
      expect(Validators.isValidEin(ein: valid), true);
      expect(Validators.isValidEin(ein: invalidShort), false);
      expect(Validators.isValidEin(ein: invalidLong), false);
      expect(Validators.isValidEin(ein: invalidFormat), false);
    });

    test("SSN validator checks SSN validity", () {
      String valid = "123456789";
      String invalidShort = "12345678";
      String invalidLong = "1234567891";
      String invalidFormat = "1!3ldgbf4 ";
      expect(Validators.isValidSsn(ssn: valid), true);
      expect(Validators.isValidSsn(ssn: invalidShort), false);
      expect(Validators.isValidSsn(ssn: invalidLong), false);
      expect(Validators.isValidSsn(ssn: invalidFormat), false);
    });

    test("Percent Ownership checks validity of percent ownership", () {
      int valid = 50;
      int invalidMin = -1;
      int invalidMax = 101;
      expect(Validators.isValidPercentOwnership(percent: valid), true);
      expect(Validators.isValidPercentOwnership(percent: invalidMin), false);
      expect(Validators.isValidPercentOwnership(percent: invalidMax), false);
    });

    test("Routing number validator checks routing number validity", () {
      String valid = "123456789";
      String invalidShort = "12345678";
      String invalidLong = "1234567891";
      String invalidFormat = "1!3ldbf4 ";
      expect(Validators.isValidRoutingNumber(routingNumber: valid), true);
      expect(Validators.isValidRoutingNumber(routingNumber: invalidShort), false);
      expect(Validators.isValidRoutingNumber(routingNumber: invalidLong), false);
      expect(Validators.isValidRoutingNumber(routingNumber: invalidFormat), false);
    });

    test("Account number validator checks account number validity", () {
      String valid = "1234567";
      String invalidShort = "12345";
      String invalidLong = "123456789123456789";
      String invalidFormat = "1!3lf4 ";
      expect(Validators.isValidAccountNumber(accountNumber: valid), true);
      expect(Validators.isValidAccountNumber(accountNumber: invalidShort), false);
      expect(Validators.isValidAccountNumber(accountNumber: invalidLong), false);
      expect(Validators.isValidAccountNumber(accountNumber: invalidFormat), false);
    });

    test("UUID validator checks UUID validity", () {
      String valid = "457fd953-44d8-4c78-9b8b-2587d679aa37";
      String invalidShort = "457fd3-44d8-4c78-9b8b-258679aa37";
      String invalidLong = "45gg7fd953-44d8-4c78-9b8b-2587d679asfa37";
      String invalidFormat = " 457fd&53-44d8-4c78-9b8b-m-2587d67^aa37";
      expect(Validators.isValidUUID(uuid: valid), true);
      expect(Validators.isValidUUID(uuid: invalidShort), false);
      expect(Validators.isValidUUID(uuid: invalidLong), false);
      expect(Validators.isValidUUID(uuid: invalidFormat), false);
    });

    test("Url Validator checks url for validity", () {
      String valid = 'https://www.google.com/';
      String invalid= 'htps://ww.!google/';
      expect(Validators.isValidUrl(url: valid), true);
      expect(Validators.isValidUrl(url: invalid), false);
    });
  });
}