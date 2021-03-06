import 'package:dashboard/models/business/photos.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/photos_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:image_picker/image_picker.dart';

class PhotosRepository extends BaseRepository {
  late PhotosProvider _photosProvider;

  PhotosRepository({required PhotosProvider photosProvider})
    : _photosProvider = photosProvider;

  Future<Photos> storeLogo({required PickedFile file, required String profileIdentifier}) async {
    Map<String, dynamic> body = {
      'photo': file,
      'is_logo': true
    };
    
    final Map<String, dynamic> json = await this.send(request: _photosProvider.storeLogo(identifier: profileIdentifier, body: body));
    return deserialize(json: json);
  }

  Future<Photos> storeBanner({required PickedFile file, required String profileIdentifier}) async {
    Map<String, dynamic> body = {
      'photo': file,
      'is_logo': false
    };
    
    final Map<String, dynamic> json = await this.send(request: _photosProvider.storeBanner(identifier: profileIdentifier, body: body));
    return deserialize(json: json);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Photos.fromJson(json: json!);
  }
}