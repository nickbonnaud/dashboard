import 'dart:convert';

import 'package:dashboard/models/token.dart';
import 'package:dashboard/providers/storage_provider.dart';

class TokenRepository {
  static const String tokenKey = 'token';
  final StorageProvider _tokenProvider = const StorageProvider();

  const TokenRepository();

  void saveToken({required Token token}) {
    _tokenProvider.write(key: tokenKey, value: jsonEncode(token.toJson()));
  }

  void deleteToken() {
    _tokenProvider.delete(key: tokenKey);
  }

  Token? fetchToken() {
    String? jsonToken = _tokenProvider.read(key: tokenKey);
    if (jsonToken == null) return null;
    return Token.fromJson(json: jsonDecode(jsonToken));
  }

  bool tokenValid() {
    Token? token = fetchToken();
    return _isValidToken(token);
  }

  bool _isValidToken(Token? token) {
    if (token == null) return false;
    DateTime now = DateTime.now();
    return token.expiry.isBefore(now);
  }
}