import 'package:flutter/material.dart';
import 'package:pest_detection/homePage.dart';
import 'package:pest_detection/widgets/backgroundImage.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:pest_detection/main.dart';
import 'package:pest_detection/widgets/roundedButton.dart';

class RealtimeDetection extends StatefulWidget {
  const RealtimeDetection({Key? key}) : super(key: key);

  @override
  State<RealtimeDetection> createState() => _RealtimeDetectionState();
}

class _RealtimeDetectionState extends State<RealtimeDetection> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = "";
  int _imageCount = 0;
  bool isClicked = true;

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
            if (_imageCount % 50 == 0) {
              _imageCount = 0;
              //runModel();
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

      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });
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
        BackgroundImage(image: 'assets/images/BG.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Realtime Pest Detection'),
            backgroundColor: Colors.green,
            automaticallyImplyLeading: false,
            leading: new IconButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Homepage())),
                icon: new Icon(Icons.arrow_back, color: Colors.white)),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
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
                'Healthy Plant',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              SizedBox(
                height: 20,
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
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Suggested Pesticide for the Infection"),
      content: Text('No need for a healthy plant'),
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

  @override
  void initState() {
    super.initState();
    //loadModel();
    loadCamera(0);
  }
}
