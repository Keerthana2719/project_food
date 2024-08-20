// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
//
// final FirebaseStorage _storage = FirebaseStorage.instance;
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
// class StoreData {
//   Future<String> uploadImageToStorage(String childName,Uint8List file) async {
//
//    Reference ref =  _storage.ref().child(childName);
//    UploadTask uploadTask = ref.putData(file);
//    TaskSnapshot snapshot = await uploadTask;
//    String downloadUrl = await snapshot.ref.getDownloadURL();
//    return downloadUrl;
//
//   }
//
//   Future<String> saveData({required String name,required String email,required Uint8List file}) async {
//     String resp = "Some Error Occured";
//     try{
//       if(name.isNotEmpty || email.isNotEmpty) {
//
//         String imageUrl = await uploadImageToStorage("profileImage", file);
//         await _firestore.collection("UserProfile").add({
//           "name": name,
//           "email": email,
//           "imageLink": imageUrl
//         });
//         resp = "success";
//       }
//     }
//         catch(err){ resp = err.toString();}return resp;
//   }
// }
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    try {
      Reference ref = _storage.ref().child(childName);
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
        String imageUrl = await uploadImageToStorage("profileImage", file);
        await _firestore.collection("UserProfile").add({
          "name": name,
          "email": email,
          "imageLink": imageUrl,
        });
        resp = "success";
      } else {
        resp = "Name and Email cannot be empty";
      }
    } catch (err) {
      resp = "Error: ${err.toString()}";
    }
    return resp;
  }
}
