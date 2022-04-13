import 'dart:async';

import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/token.dart';
import 'package:dashboard/providers/authentication_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';

class AuthenticationRepository extends BaseRepository {
  final TokenRepository _tokenRepository;
  final AuthenticationProvider _authenticationProvider;

  const AuthenticationRepository({required AuthenticationProvider authenticationProvider, required TokenRepository tokenRepository})
    : _tokenRepository = tokenRepository,
      _authenticationProvider = authenticationProvider;

  Future<Business> register({required String email, required String password, required String passwordConfirmation}) async {
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation
    };
    Map<String, dynamic> json = await send(request: _authenticationProvider.register(body: body));
    return deserialize(json: json);
  }
  
  Future<Business> login({required String email, required String password}) async {
    Map<String, dynamic> body = {
      "email": email,
      "password": password
    };
    
    Map<String, dynamic> json = await send(request: _authenticationProvider.login(body: body));
    return deserialize(json: json);
  }
  
  Future<bool> logout() async {
    return send(request: _authenticationProvider.logout())
      .then((json) {
        _tokenRepository.deleteToken();
        return json['success'];
      });
  }

  Future<bool> verifyPassword({required String password}) async {
    Map<String, dynamic> body = {
      'password': password
    };

    Map<String, dynamic> json = await send(request: _authenticationProvider.verifyPassword(body: body));
    return json['password_verified'];
  }

  Future<bool> requestPasswordReset({required String email}) async {
    Map<String, dynamic> body = {
      'email': email
    };

    Map<String, dynamic> json = await send(request: _authenticationProvider.requestPasswordReset(body: body));
    return json['email_sent'];
  }

  Future<bool> resetPassword({required String password, required String passwordConfirmation, required String token}) async {
    Map<String, dynamic> body = {
      'password': password,
      'password_confirmation': passwordConfirmation,
      'token': token
    };

    Map<String, dynamic> json = await send(request: _authenticationProvider.resetPassword(body: body));
    return json['reset'];
  }

  bool isSignedIn() {
    return _tokenRepository.tokenValid();
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    _tokenRepository.saveToken(token: Token.fromJson(json: json!['csrf_token']));
    return Business.fromJson(json: json['business']);
  }
}