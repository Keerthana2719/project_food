import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'ep.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _profileImage;
  String? _name;
  String? _email;
  String? _profileImageUrl;

  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final doc =
          await _firestore.collection('profiles').doc('user_profile_id').get();
      if (doc.exists) {
        final userData = doc.data() as Map<String, dynamic>;
        setState(() {
          _name = userData['name'] ?? 'No Name';
          _email = userData['email'] ?? 'No Email';
          _profileImageUrl = userData['profileImage'];
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_profileImage == null) return;

    try {
      // Create a unique file name
      String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the file to Firebase Storage
      TaskSnapshot snapshot = await _storage
          .ref()
          .child('profiles/$fileName')
          .putFile(_profileImage!);

      // Get the download URL of the uploaded file
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with the new image URL
      await _firestore.collection('profiles').doc('user_profile_id').update({
        'profileImage': downloadUrl,
      });

      // Update the UI
      setState(() {
        _profileImageUrl = downloadUrl;
      });

      print('Profile image uploaded successfully');
    } catch (e) {
      print('Error uploading profile image: $e');
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        endDrawer: Container(
          width: 200, // Set the desired width of the drawer here
          color: Colors.black,
          child: Drawer(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100, // Adjust height as needed
                      child: Row(
                        children: [
                          Icon(
                            Icons.nightlight_round,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Dark Mode",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    // You can add more widgets here if needed
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 9,
                            spreadRadius: 1,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/back.png",
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: _openDrawer,
                  ),
                ],
              ),
              SizedBox(height: 35),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _profileImage != null
                          ? Image.file(
                              _profileImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : _profileImageUrl != null
                              ? Image.network(
                                  _profileImageUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/camera.png",
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey,
                                ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name ?? " ",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _email ?? " ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfile()),
                  );
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black,
                ),
                child: Center(
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
