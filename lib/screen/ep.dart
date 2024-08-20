import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  XFile? _image;

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final fileName = DateTime.now().toIso8601String(); // Unique file name
      final storageRef = _storage.ref().child('profile_images/$fileName');
      final uploadTask = storageRef.putFile(image);

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('Image uploaded: $downloadUrl'); // Debug statement
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text;
    final email = _emailController.text;

    String? imageUrl;
    if (_image != null) {
      final file = File(_image!.path);
      imageUrl = await _uploadImage(file);
    }

    try {
      final userId = 'user_profile_id'; // Replace with actual user ID
      await _firestore.collection('profiles').doc(userId).set({
        'name': name,
        'email': email,
        if (imageUrl != null) 'profileImage': imageUrl,
      });
      Navigator.of(context).pop(); // Navigate back to the previous screen
    } catch (e) {
      print('Error saving profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _image != null
                          ? FileImage(File(_image!.path))
                          : null,
                      child: _image == null
                          ? Image.asset("assets/camera.png", width: 40, height: 40, color: Colors.grey)
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text("Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 20),
                Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    ),
                    child: Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});
//
//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }
//
// class _EditProfileState extends State<EditProfile> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController(); // Added phone controller
//   XFile? _image;
//
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = pickedFile;
//       });
//     }
//   }
//
//   Future<String?> _uploadImage(File image) async {
//     try {
//       final fileName = DateTime.now().toIso8601String(); // Unique file name
//       final storageRef = _storage.ref().child('profile_images/$fileName');
//       final uploadTask = storageRef.putFile(image);
//
//       final snapshot = await uploadTask.whenComplete(() => {});
//       final downloadUrl = await snapshot.ref.getDownloadURL();
//       print('Image uploaded: $downloadUrl'); // Debug statement
//       return downloadUrl;
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }
//
//   Future<void> _saveProfile() async {
//     final name = _nameController.text;
//     final email = _emailController.text;
//     final phone = _phoneController.text;
//
//     String? imageUrl;
//     if (_image != null) {
//       final file = File(_image!.path);
//       imageUrl = await _uploadImage(file);
//     }
//
//     try {
//       final userId = 'user_profile_id'; // Replace with actual user ID
//       await _firestore.collection('profiles').doc(userId).set({
//         'name': name,
//         'email': email,
//         'phone': phone, // Added phone number
//         if (imageUrl != null) 'profileImage': imageUrl,
//       });
//       Navigator.of(context).pop(); // Navigate back to the previous screen
//     } catch (e) {
//       print('Error saving profile: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Padding(
//           padding: const EdgeInsets.all(25),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20),
//                 Center(
//                   child: GestureDetector(
//                     onTap: _pickImage,
//                     child: CircleAvatar(
//                       radius: 60,
//                       backgroundColor: Colors.grey[200],
//                       backgroundImage: _image != null
//                           ? FileImage(File(_image!.path))
//                           : null,
//                       child: _image == null
//                           ? Image.asset('assets/images/camera.png', width: 40, height: 40, color: Colors.grey)
//                           : null,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Text("Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 15),
//                 TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     hintText: "Enter your name",
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 15),
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     hintText: "Enter your email",
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text("Phone", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Added phone label
//                 SizedBox(height: 15),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: InputDecoration(
//                     hintText: "Enter your phone number",
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
//                   ),
//                 ),
//                 SizedBox(height: 40),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       await _saveProfile();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       backgroundColor: Colors.blue,
//                       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
//                     ),
//                     child: Text(
//                       "Save Changes",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
