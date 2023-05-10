import 'package:doctor/pages/home.dart';
import 'package:doctor/pages/mypatient.dart';
import 'package:doctor/pages/newpatient.dart';
import 'package:doctor/pages/patient_details.dart';
import 'package:doctor/pages/profile.dart';
import 'package:doctor/pages/reset_password.dart';
import 'package:doctor/pages/signup_section.dart';
import 'package:doctor/pages/user_guide.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:doctor/pages/login_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     final bool isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
         
  runApp(MyApp(isUserLoggedIn: isUserLoggedIn));


}


class MyApp extends StatelessWidget {
  final bool isUserLoggedIn;
  MyApp({required this.isUserLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: isUserLoggedIn ? Home_section() : login_section(),
    );
  }
}


class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return 
        ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.all(12)),
            backgroundColor: MaterialStatePropertyAll(Colors.deepPurpleAccent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                 fontWeight: FontWeight.bold,
                  fontSize: 25),
          ),
          onPressed: onPressed,
       );
  }
}

