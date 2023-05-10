import 'package:doctor/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Reset_Password extends StatefulWidget {
  const Reset_Password({super.key});

  @override
  State<Reset_Password> createState() => _Reset_PasswordState();
}

class _Reset_PasswordState extends State<Reset_Password> {
  var primaryColor = Colors.deepPurpleAccent;
  TextEditingController emailController = TextEditingController();
  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send password reset email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(primaryColor),
                    elevation: null,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                  ),
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Image.asset("assets/reset.png"),
              SizedBox(
                height: 20,
              ),
              Text(
                "Forget Password",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Enter Your Email And Click (Send Code) for Reset Password"),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Via Email',
                  prefixIcon: Container(
                      margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        color: Color.fromARGB(255, 181, 170, 216)    
                        ),
                         child: Padding(
                           padding: const EdgeInsets.all(10),
                           child: Icon(Icons.email,color: Colors.deepPurpleAccent,),
                         )),
                  ),
                    ),
              
              SizedBox(height: 16),
              CustomButton(text: "Send Code", onPressed: resetPassword)
            ],
          ),
        ),
      ),
    );
  }
}
