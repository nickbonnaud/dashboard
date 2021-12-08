import 'package:image_picker/image_picker.dart';

class PhotoPickerProvider {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickPhoto() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }
}