import 'package:doctor/pages/user_guide.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor/main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class signup_section extends StatefulWidget {
  const signup_section({super.key});

  @override
  State<signup_section> createState() => _signup_sectionState();
}

class _signup_sectionState extends State<signup_section> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();



  Future<void> _submit() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text,
        'email': _emailController.text,
        'number_phone': _numberController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('تم تسجيل الحساب بنجاح')));
          _formKey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                 password: _passwordController.text
                 );
        User? user = FirebaseAuth.instance.currentUser;
        String uid = user!.uid;
        SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setBool('isUserLoggedIn', true);
prefs.setString("uid", uid);
 Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Welcome_screen()));
        
        } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('لا يوجد مستخدم بهذا البريد الإلكتروني.');
        } else if (e.code == 'wrong-password') {
          print('كلمة المرور غير صحيحة.');
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    "Let's You In",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent),
                  ),
                  Text(
                    "Fill out the data",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  height: 150,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.deepPurpleAccent,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset('assets/doctor_photo'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                          validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please entery your name';
                      }
                      return null;
                    },
                        decoration: InputDecoration(
                          hintText: "Enter your name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _usernameController,
                          validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please entery your UserName';
                      }
                      return null;
                    },
                        decoration: InputDecoration(
                          hintText: "Enter your username",
                          
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _emailController,
                          validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please entery your Email';
                      }
                      return null;
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
                        controller: _passwordController,
                        obscureText: true,
                         validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter password';
                      }
                      return null;
                    },
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _numberController,
                          validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please entery your Number';
                      }
                      return null;
                    },
                        decoration: InputDecoration(
                          hintText: "Enter your phone",
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
                  text: "Next",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submit();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}