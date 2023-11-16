import 'package:flutter/material.dart';
import 'package:pest_detection/homePage.dart';
import 'package:pest_detection/widgets/backgroundImage.dart';
import 'package:pest_detection/widgets/roundedButton.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import 'db.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  late DatabaseHelper dbHelper = DatabaseHelper();
  String output = "";
  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  String temp = "";

  File? _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/BG.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Upload Image'),
            backgroundColor: Colors.green,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const Homepage())),
                icon: const Icon(Icons.arrow_back, color: Colors.white)),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                height: 250,
                child: _image != null
                    ? Image.file(_image!)
                    : const Text(
                        "No image selected",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              RoundedButton(
                  buttonName: "Upload",
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  }),
              const SizedBox(
                height: 50,
              ),
              RoundedButton(
                  buttonName: "Detect",
                  onPressed: () {
                    loadModel();
                    runModel();
                  }),
              const SizedBox(
                height: 50,
              ),
              Text(
                output,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 50,
              ),
              RoundedButton(
                  buttonName: "Pesticide Suggetions",
                  onPressed: () async {
                    temp = output.substring(2, 4);

                    List<Map<String, dynamic>> incompleteTasks =
                        await dbHelper.getPesticide(temp);

                    for (var task in incompleteTasks) {
                      showAlertDialog(context, task['pesticide']);
                    }
                  }),
            ],
          ),
        )
      ],
    );
  }

  showAlertDialog(BuildContext context, String content) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Suggested Pesticide for the Infection"),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/models/pestDetection.tflite",
        labels: "assets/models/labels.txt");
  }

  runModel() async {
    var predictions = await Tflite.runModelOnImage(
        path: _imageFile.path,
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true);

    for (var element in predictions!) {
      setState(() {
        output = element['label'];
      });
    }

    print(output);
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      dbHelper.initializeDatabase();
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageFile = pickedFile;
        print('Image selected.');
        print(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
