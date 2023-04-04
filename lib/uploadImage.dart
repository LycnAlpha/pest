import 'package:flutter/material.dart';
import 'package:pest_detection/homePage.dart';
import 'package:pest_detection/widgets/backgroundImage.dart';
import 'package:pest_detection/widgets/roundedButton.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String output = "";
  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  File? _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(image: 'assets/images/BG.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Upload Image'),
            backgroundColor: Colors.green,
            automaticallyImplyLeading: false,
            leading: new IconButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Homepage())),
                icon: new Icon(Icons.arrow_back, color: Colors.white)),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                height: 250,
                child: _image != null
                    ? Image.file(_image!)
                    : Text(
                        "No image selected",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              RoundedButton(
                  buttonName: "Upload",
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  }),
              SizedBox(
                height: 50,
              ),
              RoundedButton(
                  buttonName: "Detect",
                  onPressed: () {
                    //loadModel();
                    // runModel();
                  }),
              SizedBox(
                height: 50,
              ),
              Text(
                '',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              SizedBox(
                height: 50,
              ),
              RoundedButton(
                  buttonName: "Pesticide Suggetions",
                  onPressed: () {
                    showAlertDialog(context);
                  }),
            ],
          ),
        )
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Suggested Pesticide for the Infection"),
      content: Text('Imidacloprid 200gl SL'),
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
    if (_imageFile != null) {
      var predictions = await Tflite.runModelOnImage(
          path: _imageFile.path,
          imageMean: 0.0, // defaults to 117.0
          imageStd: 255.0, // defaults to 1.0
          numResults: 2, // defaults to 5
          threshold: 0.2, // defaults to 0.1
          asynch: true);

      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });

      print(output);
    }
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
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
