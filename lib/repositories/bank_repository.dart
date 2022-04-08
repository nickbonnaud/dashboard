import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/bank_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class BankRepository extends BaseRepository {
  final BankProvider _bankProvider;

  BankRepository({required BankProvider bankProvider})
    : _bankProvider = bankProvider;

  Future<BankAccount> store({
    required String firstName,
    required String lastName,
    required String routingNumber,
    required String accountNumber,
    required String accountType,
    required String address,
    required String addressSecondary,
    required String city,
    required String state,
    required String zip
  }) async {
    final Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName,
      'routing_number': routingNumber,
      'account_number': accountNumber,
      'account_type': accountType,
      'address': address,
      'address_secondary': addressSecondary,
      'city': city,
      'state': state,
      'zip': zip
    };
    
    Map<String, dynamic> json = await send(request: _bankProvider.store(body: body));
    return deserialize(json: json);
  }

  Future<BankAccount> update({
    required String identifier,
    required String firstName,
    required String lastName,
    required String routingNumber,
    required String accountNumber,
    required String accountType,
    required String address,
    required String addressSecondary,
    required String city,
    required String state,
    required String zip
  }) async {
    final Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName,
      'routing_number': routingNumber,
      'account_number': accountNumber,
      'account_type': accountType,
      'address': address,
      'address_secondary': addressSecondary,
      'city': city,
      'state': state,
      'zip': zip
    };

    Map<String, dynamic> json = await send(request: _bankProvider.update(body: body, identifier: identifier));
    return deserialize(json: json);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return BankAccount.fromJson(json: json!);
  }
}