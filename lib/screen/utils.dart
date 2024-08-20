import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<Uint8List> pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile != null) {
    return await pickedFile.readAsBytes();
  } else {
    throw Exception('No image selected');
  }
}
