import 'package:doctor/main.dart';
import 'package:doctor/pages/home.dart';
import 'package:doctor/pages/reset_password.dart';
import 'package:doctor/pages/signup_section.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login_section extends StatefulWidget {
  const login_section({super.key});

  @override
  State<login_section> createState() => _login_sectionState();
}

class _login_sectionState extends State<login_section> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/login_photo.jpeg"),
              SizedBox(
                height: 60,
              ),
              Row(
                children: [
                  Text(
                    "WELCOME BACK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Icon(
                    Icons.front_hand,
                    color: Colors.amber,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Log In",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال البريد الإلكتروني';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'يرجى إدخال بريد إلكتروني صالح';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!.trim();
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your mail",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter your password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!.trim();
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Log in",
                  onPressed: _submit,
                ),
              ),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  TextButton(
                    child: Text(
                      "Reset Password",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: (){
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Reset_Password()));
                      
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account?",
                    style: TextStyle(color: Colors.black12),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => signup_section()));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _email!,
                 password: _password!
                 );
        User? user = FirebaseAuth.instance.currentUser;
        String uid = user!.uid;
        SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setBool('isUserLoggedIn', true);
prefs.setString("uid", uid);
 Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home_section()));
        
        } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('لا يوجد مستخدم بهذا البريد الإلكتروني.');
        } else if (e.code == 'wrong-password') {
          print('كلمة المرور غير صحيحة.');
        }
      }
    }
  }
}

