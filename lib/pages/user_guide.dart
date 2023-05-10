import 'package:doctor/main.dart';
import 'package:doctor/pages/home.dart';
import 'package:flutter/material.dart';

class Welcome_screen extends StatefulWidget {
  const Welcome_screen({super.key});

  @override
  State<Welcome_screen> createState() => _Welcome_screenState();
}

class _Welcome_screenState extends State<Welcome_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(157),
                bottomRight: Radius.circular(157),
              ),
              color: Color.fromARGB(255, 41, 171, 223),
            ),
            width: double.infinity,
            child: Image.asset(
              "assets/assistant_photo.jpeg",
              width: 100,
              height: 350,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Your Assistant",
            style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "The application helps detect leukemia through a blood sample that is carefully examined by the application",
              style: TextStyle(color: Colors.black, fontSize: 20,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Get Started",
                onPressed: () {
                   Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home_section()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
