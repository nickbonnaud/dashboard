import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/business_account_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class BusinessAccountRepository extends BaseRepository {
  final BusinessAccountProvider _accountProvider;

  const BusinessAccountRepository({required BusinessAccountProvider accountProvider})
    : _accountProvider = accountProvider;

  Future<BusinessAccount> store({
    required String name,
    required String address,
    required String addressSecondary,
    required String city,
    required String state,
    required String zip,
    required String entityType,
    String? ein
  }) async {
    final Map<String, dynamic> body = {
      'business_name': name,
      'entity_type': entityType,
      'address': address,
      'address_secondary': addressSecondary,
      'city': city,
      'state': state,
      'zip': zip
    };
    
    if (ein != null && ein != "") body.addAll({'ein': ein});

    Map<String, dynamic> json = await send(request: _accountProvider.store(body: body));
    return deserialize(json: json);
  }

  Future<BusinessAccount> update({
    required String name,
    required String address,
    required String addressSecondary,
    required String city,
    required String state,
    required String zip,
    required String entityType,
    required String identifier,
    String? ein,
  }) async {
    Map<String, dynamic> body = {
      'business_name': name,
      'entity_type': entityType,
      'address': address,
      'address_secondary': addressSecondary,
      'city': city,
      'state': state,
      'zip': zip
    };

    if (ein != null && ein != "") body.addAll({'ein': ein});

    Map<String, dynamic> json = await send(request: _accountProvider.update(body: body, identifier: identifier));
    return deserialize(json: json);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return BusinessAccount.fromJson(json: json!);
  }
}