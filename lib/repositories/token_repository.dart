import 'dart:convert';

import 'package:dashboard/models/token.dart';
import 'package:dashboard/providers/storage_provider.dart';

const String TOKEN_KEY = 'token';

class TokenRepository {
  final StorageProvider _tokenProvider = StorageProvider();

  void saveToken({required Token token}) {
    _tokenProvider.write(key: TOKEN_KEY, value: jsonEncode(token.toJson()));
  }

  void deleteToken() {
    _tokenProvider.delete(key: TOKEN_KEY);
  }

  Token? fetchToken() {
    String? jsonToken = _tokenProvider.read(key: TOKEN_KEY);
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