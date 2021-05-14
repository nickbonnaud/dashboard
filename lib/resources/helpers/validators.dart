class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final RegExp _phoneRegExp = RegExp(
    r'^-?[0-9]+$'
  );

  static final RegExp _einRegExp = RegExp(
    r'^\d{2}\-\d{7}$'
  );

  static final RegExp _alphaSpaceDot = RegExp(
    r'^[a-zA-Z\s-.]*$'
  );

  static final RegExp _numeric = RegExp(
    r'^[0-9]*$'
  );

  static final RegExp _uuid = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$'
  );


  static final RegExp _ipv4Maybe = RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');

  static final RegExp _ipv6 = RegExp(r'^::|^::1|^([a-fA-F0-9]{1,4}::?){1,7}([a-fA-F0-9]{1,4})$');
  
  static bool isValidEmail({required String email}) => _emailRegExp.hasMatch(email);

  static isValidPassword({required String password}) {
    if (password.isEmpty) return false;

    bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowerCase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[-!@#$%^&*_+=(),.?":{}|<>]'));
    bool hasMinLength = password.length >= 8;

    return hasUpperCase && hasLowerCase && hasDigits && hasSpecialCharacters && hasMinLength;
  }

  static isPasswordConfirmationValid({required String password, required String passwordConfirmation}) => password == passwordConfirmation;

  static isValidBusinessName({required String name}) => name.length >= 2;

  static isValidFirstName({required String name}) => name.length >= 2;

  static isValidLastName({required String name}) => name.length >= 2;

  static isValidPhone({required String phone}) => phone.length == 10 && _phoneRegExp.hasMatch(phone);

  static isValidBusinessDescription({required String description}) => description.length >= 50;

  static isValidAddress({required String address}) => address.length > 3;

  static isValidAddressSecondary({required String address}) => address.isEmpty || address.length > 1;

  static isValidCity({required String city}) => city.length >= 3 && _alphaSpaceDot.hasMatch(city);

  static isValidZip({required String zip}) => zip.length == 5 && _numeric.hasMatch(zip);

  static isValidEin({required String ein}) => ein.length == 10 && _einRegExp.hasMatch(ein);

  static isValidSsn({required String ssn}) => _numeric.hasMatch(ssn) && ssn.length == 9;

  static isValidPercentOwnership({required int percent}) => _numeric.hasMatch(percent.toString()) && percent > 0 && percent <= 100;

  static isValidRoutingNumber({required String routingNumber}) => _numeric.hasMatch(routingNumber) && routingNumber.length == 9;

  static isValidAccountNumber({required String accountNumber}) => _numeric.hasMatch(accountNumber) && (6 <= accountNumber.length && accountNumber.length <= 17);

  static isValidUUID({required String uuid}) => _uuid.hasMatch(uuid);

  static isValidUrl({required String url}) {
    if (url.isEmpty ||
      url.length > 2083 ||
      url.indexOf('mailto:') == 0) {
    return false;
  }

  Map options = {
    'protocols': ['http', 'https'],
    'require_tld': true,
    'require_protocol': false,
    'allow_underscores': false
  };

    var protocol,
        user,
        pass,
        auth,
        host,
        hostname,
        port,
        portStr,
        path,
        query,
        hash,
        split;

    // check protocol
    split = url.split('://');
    if (split.length > 1) {
      protocol = _shift(split);
      if (options['protocols'].indexOf(protocol) == -1) {
        return false;
      }
    } else if (options['require_protocol'] == true) {
      return false;
    }
    url = split.join('://');

    // check hash
    split = url.split('#');
    url = _shift(split);
    hash = split.join('#');
    if (hash != null && hash != "" && RegExp(r'\s').hasMatch(hash)) {
      return false;
    }

    // check query params
    split = url.split('?');
    url = _shift(split);
    query = split.join('?');
    if (query != null && query != "" && RegExp(r'\s').hasMatch(query)) {
      return false;
    }

    // check path
    split = url.split('/');
    url = _shift(split);
    path = split.join('/');
    if (path != null && path != "" && RegExp(r'\s').hasMatch(path)) {
      return false;
    }

    // check auth type urls
    split = url.split('@');
    if (split.length > 1) {
      auth = _shift(split);
      if (auth.indexOf(':') >= 0) {
        auth = auth.split(':');
        user = _shift(auth);
        if (!RegExp(r'^\S+$').hasMatch(user)) {
          return false;
        }
        pass = auth.join(':');
        if (!RegExp(r'^\S*$').hasMatch(pass)) {
          return false;
        }
      }
    }

    // check tld
    List parts = url.split('.');
    if (parts.length < 3) return false;
    if (options['require_tld']) {
      var tld = parts.removeLast();
      if (parts.isEmpty || !RegExp(r'^[a-z]{2,}$').hasMatch(tld)) {
        return false;
      }
    }

    // check hostname
    hostname = split.join('@');
    split = hostname.split(':');
    host = _shift(split);
    if (split.length > 0) {
      portStr = split.join(':');
      try {
        port = int.parse(portStr, radix: 10);
      } catch (e) {
        return false;
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(portStr) || port <= 0 || port > 65535) {
        return false;
      }
    }

    if (!_isIP(host) && !_isFQDN(host) && host != 'localhost') {
      return false;
    }

    if (options['host_whitelist'] == true &&
        options['host_whitelist'].indexOf(host) == -1) {
      return false;
    }

    if (options['host_blacklist'] == true &&
        options['host_blacklist'].indexOf(host) != -1) {
      return false;
    }

    return true;
  }

  
  static _shift(List l) {
    if (l.isNotEmpty) {
      var first = l.first;
      l.removeAt(0);
      return first;
    }
    return null;
  }

  static bool _isIP(String str, [version]) {
    version = version.toString();
    if (version == 'null') {
      return _isIP(str, 4) || _isIP(str, 6);
    } else if (version == '4') {
      if (!_ipv4Maybe.hasMatch(str)) {
        return false;
      }
      var parts = str.split('.');
      parts.sort((a, b) => int.parse(a) - int.parse(b));
      return int.parse(parts[3]) <= 255;
    }
    return version == '6' && _ipv6.hasMatch(str);
  }

  static bool _isFQDN(str) {
    Map options = {'require_tld': true, 'allow_underscores': false};
    List parts = str.split('.');
    if (options['require_tld']) {
      var tld = parts.removeLast();
      if (parts.isEmpty || !RegExp(r'^[a-z]{2,}$').hasMatch(tld)) {
        return false;
      }
    }

    for (var part, i = 0; i < parts.length; i++) {
      part = parts[i];
      if (options['allow_underscores']) {
        if (part.indexOf('__') >= 0) {
          return false;
        }
      }
      if (!RegExp(r'^[a-z\\u00a1-\\uffff0-9-]+$').hasMatch(part)) {
        return false;
      }
      if (part[0] == '-' ||
          part[part.length - 1] == '-' ||
          part.indexOf('---') >= 0) {
        return false;
      }
    }
    return true;
  }
}