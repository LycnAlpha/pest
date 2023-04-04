import 'package:flutter/material.dart';
import 'package:pest_detection/welcome.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pest Detection and Pesticide Suggesition System',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const welcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
