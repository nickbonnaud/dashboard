import 'package:image_picker/image_picker.dart';

class PhotoPickerProvider {
  final ImagePicker _picker = ImagePicker();

  Future<PickedFile?> pickPhoto() async {
    return await _picker.getImage(source: ImageSource.gallery);
  }
}