import 'package:flutter/material.dart';
import 'package:pest_detection/homePage.dart';
import 'package:pest_detection/widgets/backgroundImage.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:pest_detection/main.dart';
import 'package:pest_detection/widgets/roundedButton.dart';

import 'db.dart';

class RealtimeDetection extends StatefulWidget {
  const RealtimeDetection({Key? key}) : super(key: key);

  @override
  State<RealtimeDetection> createState() => _RealtimeDetectionState();
}

class _RealtimeDetectionState extends State<RealtimeDetection> {
  late DatabaseHelper dbHelper = DatabaseHelper();
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = "";
  int _imageCount = 0;
  bool isClicked = true;
  String temp = "";

  @override
  void initState() {
    super.initState();
    loadModel();
    loadCamera(0);
    dbHelper.initializeDatabase();
  }

  loadCamera(int c) {
    cameraController = CameraController(cameras![c], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((ImageStream) async {
            cameraImage = ImageStream;
            _imageCount++;
            if (_imageCount % 30 == 0) {
              _imageCount = 0;
              runModel();
            }

            //await Tflite.close();
          });
        });
      }
    });
  }

  runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map((Plane) {
          return Plane.bytes;
        }).toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );

      for (var element in predictions!) {
        setState(() {
          output = element['label'];
        });
      }
    }
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/models/pestDetection.tflite",
        labels: "assets/models/labels.txt");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/BG.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Realtime Pest Detection'),
            backgroundColor: Colors.green,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Homepage())),
                icon: const Icon(Icons.arrow_back, color: Colors.white)),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: !cameraController!.value.isInitialized
                      ? Container()
                      : AspectRatio(
                          aspectRatio: cameraController!.value.aspectRatio,
                          child: CameraPreview(cameraController!),
                        ),
                ),
              ),
              Text(
                output,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundedButton(
                  buttonName: "Pesticide Suggetions",
                  onPressed: () async {
                    temp = output.substring(2);
                    print(temp);

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
    // Create button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
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
}
