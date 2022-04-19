import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/owner_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class OwnerRepository extends BaseRepository {
  final OwnerProvider? _ownerProvider;

  const OwnerRepository({OwnerProvider? ownerProvider})
    : _ownerProvider = ownerProvider;
  
  Future<OwnerAccount> store({
    required String firstName,
    required String lastName,
    required String title,
    required String phone,
    required String email,
    required bool primary,
    required int percentOwnership,
    required String dob,
    required String ssn,
    required String address,
    required String addressSecondary,
    required String city,
    required String state,
    required String zip,
  }) async {
    Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName,
      'title': title,
      'phone': phone,
      'email': email,
      'primary': primary,
      'percent_ownership': percentOwnership,
      'dob': dob,
      'ssn': ssn,
      'address': address,
      'address_secondary': addressSecondary,
      'city': city,
      'state': state,
      'zip': zip
    };
    
    OwnerProvider ownerProvider = _getOwnerProvider();
    Map<String, dynamic> json = await send(request: ownerProvider.store(body: body));
    return deserialize(json: json);
  }

  Future<OwnerAccount> update({
    required String identifier,
    required String firstName,
    required String lastName,
    required String title,
    required String phone,
    required String email,
    required bool primary,
    required int percentOwnership,
    required String dob,
    required String ssn,
    required String address,
    required String? addressSecondary,
    required String city,
    required String state,
    required String zip,
  }) async {
    Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName,
      'title': title,
      'phone': phone,
      'email': email,
      'primary': primary,
      'percent_ownership': percentOwnership,
      'dob': dob,
      'ssn': ssn,
      'address': address,
      'address_secondary': addressSecondary,
      'city': city,
      'state': state,
      'zip': zip
    };
    
    OwnerProvider ownerProvider = _getOwnerProvider();
    Map<String, dynamic> json = await send(request: ownerProvider.update(identifier: identifier, body: body));
    return deserialize(json: json);
  }

  Future<bool> remove({required String identifier}) async {
    OwnerProvider ownerProvider = _getOwnerProvider();
    await send(request: ownerProvider.remove(identifier: identifier));
    return true;
  }

  OwnerProvider _getOwnerProvider() {
    return _ownerProvider ?? const OwnerProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return OwnerAccount.fromJson(json: json!);
  }
}