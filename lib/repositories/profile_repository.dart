import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/profile_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class ProfileRepository extends BaseRepository {
  late ProfileProvider _profileProvider;

  ProfileRepository({required ProfileProvider profileProvider})
    : _profileProvider = profileProvider;

  Future<Profile> store({
    required String name,
    required String website,
    required String description,
    required String phone,
  }) async {
    final Map<String, dynamic> body = {
      'name': name,
      'website': website,
      'description': description,
      'phone': phone,
    };
    
    final Map<String, dynamic> json = await this.send(request: _profileProvider.store(body: body));
    return deserialize(json: json);
  }

  Future<Profile> update({
    required String name,
    required String website,
    required String description,
    required String phone,
    required String identifier
  }) async {
    final Map<String, dynamic> body = {
      'name': name,
      'website': website,
      'description': description,
      'phone': phone,
    };

    final Map<String, dynamic> json = await this.send(request: _profileProvider.update(body: body, identifier: identifier));
    return deserialize(json: json);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Profile.fromJson(json: json!);
  }
}