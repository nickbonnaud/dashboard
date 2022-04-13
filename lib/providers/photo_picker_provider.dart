import 'package:image_picker/image_picker.dart';

class PhotoPickerProvider {

  const PhotoPickerProvider();

  Future<XFile?> pickPhoto() async {
    ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }
}