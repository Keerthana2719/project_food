import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateMenu extends StatefulWidget {
  const UpdateMenu({Key? key}) : super(key: key);

  @override
  State<UpdateMenu> createState() => _UpdateMenuState();
}

class _UpdateMenuState extends State<UpdateMenu> {
  final usernameController = TextEditingController();
  final userPriceController = TextEditingController();
  final userColorController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  late CollectionReference<Map<String, dynamic>> bikesCollection;

  @override
  void initState() {
    super.initState();
    bikesCollection = FirebaseFirestore.instance.collection('bikes');
  }

  Future<void> getImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> uploadImage() async {
    if (_image == null) return;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('bike_images/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(_image!);

      final imageUrl = await ref.getDownloadURL();
      await saveData(imageUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> saveData(String imageUrl) async {
    final bikeData = {
      'name': usernameController.text,
      'price': int.tryParse(userPriceController.text) ?? 0,
      'color': userColorController.text,
      'image': imageUrl,
    };

    try {
      await bikesCollection.add(bikeData);
      Navigator.pop(context);
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Updating Bike'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 50),
                const Text(
                  'Updating data in Firestore',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: getImage,
                  child: _image == null
                      ? Icon(Icons.add_a_photo)
                      : Image.file(_image!),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Enter Bike Name',
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: userPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Price',
                    hintText: 'Enter Bike Price',
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: userColorController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Color',
                    hintText: 'Enter Bike Color',
                  ),
                ),
                SizedBox(height: 30),
                MaterialButton(
                  onPressed: () async {
                    await uploadImage();
                    userColorController.clear();
                    usernameController.clear();
                    userPriceController.clear();

                  },
                  child: const Text('Update Data'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  minWidth: 300,
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}