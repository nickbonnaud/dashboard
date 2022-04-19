import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/token.dart';
import 'package:dashboard/providers/business_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';

class BusinessRepository extends BaseRepository {
  final BusinessProvider? _businessProvider;
  final TokenRepository? _tokenRepository;

  const BusinessRepository({BusinessProvider? businessProvider, TokenRepository? tokenRepository})
    : _businessProvider = businessProvider,
      _tokenRepository = tokenRepository;
  
  Future<Business> fetch() async {
    BusinessProvider businessProvider = _getBusinessProvider();
    
    Map<String, dynamic> json = await send(request: businessProvider.fetch());
    return deserialize(json: json);
  }

  Future<String> updateEmail({required String email, required String identifier}) async {
    Map<String, dynamic> body = {
      'email': email
    };
    
    BusinessProvider businessProvider = _getBusinessProvider();
    Map<String, dynamic> json = await send(request: businessProvider.update(body: body, identifier: identifier));
    return json['email'];
  }

  Future<bool> updatePassword({required String password, required String passwordConfirmation, required String identifier}) async {
    Map<String, dynamic> body = {
      'password': password,
      'password_confirmation': passwordConfirmation
    };

    BusinessProvider businessProvider = _getBusinessProvider();
    await send(request: businessProvider.update(body: body, identifier: identifier));
    return true;
  }

  BusinessProvider _getBusinessProvider() {
    return _businessProvider ?? const BusinessProvider();
  }

  TokenRepository _getTokenRepository() {
    return _tokenRepository ?? const TokenRepository();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    TokenRepository tokenRepository = _getTokenRepository();
    
    tokenRepository.saveToken(token: Token.fromJson(json: json!['csrf_token']));
    return Business.fromJson(json: json['business']);
  }
}