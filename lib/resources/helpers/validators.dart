import 'package:validators/validators.dart';

class Validators {

  static final RegExp _einRegExp = RegExp(
    r'^\d{2}\-\d{7}$'
  );

  static final RegExp _alphaSpaceDot = RegExp(
    r'^[a-zA-Z\s-.]*$'
  );
  
  static bool isValidEmail({required String email}) => isEmail(email);

  static isValidPassword({required String password}) {
    if (password.isEmpty) return false;

    final bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowerCase = password.contains(RegExp(r'[a-z]'));
    final bool hasDigits = password.contains(RegExp(r'[0-9]'));
    final bool hasSpecialCharacters = password.contains(RegExp(r'[-!@#$%^&*_+=(),.?":{}|<>]'));
    final bool hasMinLength = password.trim().length >= 8;

    return hasUpperCase && hasLowerCase && hasDigits && hasSpecialCharacters && hasMinLength;
  }

  static bool isPasswordConfirmationValid({required String password, required String passwordConfirmation}) => password == passwordConfirmation;

  static bool isValidBusinessName({required String name}) => name.trim().length >= 2;

  static bool isValidFirstName({required String name}) => name.trim().length >= 2;

  static bool isValidLastName({required String name}) => name.trim().length >= 2;

  static bool isValidPhone({required String phone}) {
    String cleanedPhone = phone.replaceAll(RegExp(r"\D"), "");
    return cleanedPhone.trim().length == 10 && isNumeric(cleanedPhone);
  }

  static bool isValidBusinessDescription({required String description}) => description.trim().length >= 50;

  static bool isValidAddress({required String address}) => address.trim().length > 3;

  static bool isValidAddressSecondary({required String address}) => address.isEmpty || address.trim().length > 1;

  static bool isValidCity({required String city}) => city.trim().length >= 3 && _alphaSpaceDot.hasMatch(city);

  static bool isValidZip({required String zip}) => isPostalCode(zip, "US");

  static bool isValidEin({required String ein}) => ein.trim().length == 10 && _einRegExp.hasMatch(ein);

  static bool isValidSsn({required String ssn}) => isNumeric(ssn) && ssn.trim().length == 9;

  static bool isValidPercentOwnership({required int percent}) => isNumeric(percent.toString()) && percent > 0 && percent <= 100;

  static bool isValidRoutingNumber({required String routingNumber}) => isNumeric(routingNumber) && routingNumber.trim().length == 9;

  static bool isValidAccountNumber({required String accountNumber}) => isNumeric(accountNumber) && (6 <= accountNumber.trim().length && accountNumber.trim().length <= 17);

  static bool isValidUUID({required String uuid}) => isUUID(uuid);

  static bool isValidUrl({required String url}) => isURL(url);
}