import 'package:dashboard/models/credentials.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/credentials_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class CredentialsRepository extends BaseRepository {
  final CredentialsProvider? _credentialsProvider;

  const CredentialsRepository({CredentialsProvider? credentialsProvider})
    : _credentialsProvider = credentialsProvider;
  
  Future<Credentials> fetch() async {
    CredentialsProvider credentialsProvider = _getCredentialsProvider();

    Map<String, dynamic> json = await send(request: credentialsProvider.fetch());
    return deserialize(json: json);
  }

  CredentialsProvider _getCredentialsProvider() {
    return _credentialsProvider ?? const CredentialsProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Credentials.fromJson(json: json!);
  }
}