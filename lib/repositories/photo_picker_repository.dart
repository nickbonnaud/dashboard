import 'package:dashboard/providers/photo_picker_provider.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPickerRepository {
  final PhotoPickerProvider _photoPickerProvider = const PhotoPickerProvider();

  const PhotoPickerRepository();

  Future<XFile?> choosePhoto() async {
    return await _photoPickerProvider.pickPhoto();
  }
}