import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    try {
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference ref = _storage.ref().child(childName).child(fileName);
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return Future.error("Error uploading image: ${e.toString()}");
    }
  }

  Future<String> saveData({
    required String name,
    required String email,
    required Uint8List file,
  }) async {
    String resp = "Some Error Occurred";
    try {
      if (name.isNotEmpty && email.isNotEmpty) {
        String imageUrl = await uploadImageToStorage("profileImages", file);
        await _firestore.collection("userProfile").add({
          "name": name,
          "email": email,
          "imageLink": imageUrl,
        });
        resp = "Profile saved successfully";
      } else {
        resp = "Name and Email cannot be empty";
      }
    } catch (err) {
      resp = "Error: ${err.toString()}";
    }
    return resp;
  }
}
