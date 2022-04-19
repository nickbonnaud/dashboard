import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/profile_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class ProfileRepository extends BaseRepository {
  final ProfileProvider? _profileProvider;

  const ProfileRepository({ProfileProvider? profileProvider})
    : _profileProvider = profileProvider;

  Future<Profile> store({
    required String name,
    required String website,
    required String description,
    required String phone,
  }) async {
    Map<String, dynamic> body = {
      'name': name,
      'website': website,
      'description': description,
      'phone': phone,
    };
    
    ProfileProvider profileProvider = _getProfileProvider();
    Map<String, dynamic> json = await send(request: profileProvider.store(body: body));
    return deserialize(json: json);
  }

  Future<Profile> update({
    required String name,
    required String website,
    required String description,
    required String phone,
    required String identifier
  }) async {
    Map<String, dynamic> body = {
      'name': name,
      'website': website,
      'description': description,
      'phone': phone,
    };

    ProfileProvider profileProvider = _getProfileProvider();
    Map<String, dynamic> json = await send(request: profileProvider.update(body: body, identifier: identifier));
    return deserialize(json: json);
  }

  ProfileProvider _getProfileProvider() {
    return _profileProvider ?? const ProfileProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Profile.fromJson(json: json!);
  }
}