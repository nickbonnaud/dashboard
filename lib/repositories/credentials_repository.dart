import 'package:dashboard/models/credentials.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/credentials_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class CredentialsRepository extends BaseRepository {
  late CredentialsProvider _credentialsProvider;

  CredentialsRepository({required CredentialsProvider credentialsProvider})
    : _credentialsProvider = credentialsProvider;
  
  Future<Credentials> fetch() async {
    final Map<String, dynamic> json = await this.send(request: _credentialsProvider.fetch());
    return deserialize(json: json);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Credentials.fromJson(json: json!);
  }
}