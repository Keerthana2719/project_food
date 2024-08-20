import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_food/resources/cc.dart';
import 'package:project_food/screen/menu.dart';
import 'package:project_food/screen/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBeyWyO2voAESWW6fAzALG-wuesYy03g8M",
      authDomain: 'project-food-84f07.firebaseapp.com',
      projectId: 'project-food-84f07',
      storageBucket: 'project-food-84f07.appspot.com',
      messagingSenderId: '1070387548455',
      appId: '1:1070387548455:android:ebd343212d52ca57f8d902',
      // measurementId: '8041727286',
    ),
  );

  // Initialize GetX controllers
  Get.put(CartController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Menu(),  // Set your initial page here
      debugShowCheckedModeBanner: false,
    );
  }
}
