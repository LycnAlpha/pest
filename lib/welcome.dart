import 'package:flutter/material.dart';
import 'package:pest_detection/homePage.dart';
import 'package:pest_detection/widgets/backgroundImage.dart';
import 'package:pest_detection/widgets/roundedButton.dart';

class welcomeScreen extends StatefulWidget {
  const welcomeScreen({Key? key}) : super(key: key);

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(image: 'assets/images/welcomeBG.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
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
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color.fromARGB(255, 15, 167, 9)),
                      ),
                      child: Text(
                        'Welcome',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.withOpacity(0.7),
                            fontFamily: 'Luicida'),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    RoundedButton(
                        buttonName: 'Lets Get Started',
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Homepage(),
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
