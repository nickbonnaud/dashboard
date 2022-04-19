import 'package:dashboard/models/business/photos.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/photos_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';
import 'package:image_picker/image_picker.dart';

class PhotosRepository extends BaseRepository {
  final PhotosProvider? _photosProvider;

  const PhotosRepository({PhotosProvider? photosProvider})
    : _photosProvider = photosProvider;

  Future<Photos> storeLogo({required XFile file, required String profileIdentifier}) async {
    Map<String, dynamic> body = {
      'photo': file,
      'is_logo': true
    };
    
    PhotosProvider photosProvider = _getPhotosProvider();
    Map<String, dynamic> json = await send(request: photosProvider.storeLogo(identifier: profileIdentifier, body: body));
    return deserialize(json: json);
  }

  Future<Photos> storeBanner({required XFile file, required String profileIdentifier}) async {
    Map<String, dynamic> body = {
      'photo': file,
      'is_logo': false
    };
    
    PhotosProvider photosProvider = _getPhotosProvider();
    Map<String, dynamic> json = await send(request: photosProvider.storeBanner(identifier: profileIdentifier, body: body));
    return deserialize(json: json);
  }

  PhotosProvider _getPhotosProvider() {
    return _photosProvider ?? const PhotosProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Photos.fromJson(json: json!);
  }
}