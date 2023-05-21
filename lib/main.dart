// import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/scan_test.dart';
import 'package:flutter_application_1/screens/launcher/scr_launcher.dart';
import 'package:flutter_application_1/screens/signin/scr_signin.dart';

// List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      // home: Home(),
      // home: ScanTestScreen(),
      home: const LauncherPage(),
    );
  }
}
