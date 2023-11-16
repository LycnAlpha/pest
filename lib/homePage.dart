import 'package:flutter/material.dart';
import 'package:pest_detection/realtimeDetection.dart';
import 'package:pest_detection/uploadImage.dart';
import 'package:pest_detection/widgets/backgroundImage.dart';
import 'package:pest_detection/widgets/roundedButton.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/BG.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        'Pest Recognition and Pesticide Suggestion System',
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Luicida'),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    RoundedButton(
                        buttonName: 'Realtime Pest Detection',
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RealtimeDetection(),
                            ))),
                    const SizedBox(
                      height: 50,
                    ),
                    RoundedButton(
                        buttonName: 'Upload Image',
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const UploadImage(),
                            )))
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
