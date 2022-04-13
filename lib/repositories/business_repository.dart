import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/models/token.dart';
import 'package:dashboard/providers/business_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';

class BusinessRepository extends BaseRepository {
  final BusinessProvider _businessProvider;
  final TokenRepository _tokenRepository;

  const BusinessRepository({required BusinessProvider businessProvider, required TokenRepository tokenRepository})
    : _businessProvider = businessProvider,
      _tokenRepository = tokenRepository;
  
  Future<Business> fetch() async {
    Map<String, dynamic> json = await send(request: _businessProvider.fetch());
    return deserialize(json: json);
  }

  Future<String> updateEmail({required String email, required String identifier}) async {
    Map<String, dynamic> body = {
      'email': email
    };
    
    Map<String, dynamic> json = await send(request: _businessProvider.update(body: body, identifier: identifier));
    return json['email'];
  }

  Future<bool> updatePassword({required String password, required String passwordConfirmation, required String identifier}) async {
    Map<String, dynamic> body = {
      'password': password,
      'password_confirmation': passwordConfirmation
    };

    await send(request: _businessProvider.update(body: body, identifier: identifier));
    return true;
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    _tokenRepository.saveToken(token: Token.fromJson(json: json!['csrf_token']));
    return Business.fromJson(json: json['business']);
  }
}