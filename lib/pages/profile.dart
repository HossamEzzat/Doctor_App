import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/main.dart';
import 'package:doctor/pages/login_section.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');

  String uid = " ";
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_uid = prefs.getString('uid') ?? '';
    setState(() {
      uid = user_uid;
    });
  }

  var primaryColor = Color.fromARGB(255, 41, 171, 223);
  primaryText() =>
      TextStyle(color: primaryColor, fontSize: 25, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(
        255,
        41,
        171,
        223,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/profile_pictures_1.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(
                        255,
                        41,
                        171,
                        223,
                      ),
                      BlendMode.modulate)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5)),
                child: Image.asset(
                  "assets/doctor_photo",
                  width: 10,
                  height: 250,
                ),
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(34))),
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (!snapshot.hasData)
                                  return CircularProgressIndicator();
                                DocumentSnapshot document = snapshot.data!;

                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          document["name"],
                                          style: primaryText(),
                                        ),
                                        Expanded(child: Container()),
                                        TextButton(
                                            child: Text("LogOut"),
                                            onPressed: () async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.remove('isUserLoggedIn');
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        login_section()),
                                              );
                                            })
                                      ],
                                    ),
                                    Text("Oncologist"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      initialValue: document["name"],
                                      decoration: InputDecoration(
                                        labelText: "Doctor Name",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      initialValue: document["email"],
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      initialValue: document["username"],
                                      decoration: InputDecoration(
                                        labelText: "Username",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      initialValue: "Oncologist",
                                      decoration: InputDecoration(
                                        labelText: "Category",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  ],
                                );
                              })))))
        ],
      ),
    );
  }
}
