import 'package:doctor/main.dart';
import 'package:doctor/pages/newpatient.dart';
import 'package:doctor/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mypatient.dart';

class Home_section extends StatefulWidget {
  const Home_section({super.key});

  @override
  State<Home_section> createState() => _Home_sectionState();
}

class _Home_sectionState extends State<Home_section> {


  int _index = 0;
  final screens = [
    NewPatient(),
    MyPatient(),
    Profile(),
  ];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          margin: EdgeInsets.only(bottom: 15,left: 25,right: 25,top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
              selectedItemColor: Colors.deepPurpleAccent,
              elevation: 2,
              currentIndex: _index,
              onTap: (value) {
                setState(() {
                  _index = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined,size: 30),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.assignment_outlined,size: 30
                    ),
                     label: ""
                     ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,size: 30
                    ),
                    label: ""
                    ),
              ]),
        ),
      ),
      body: screens[_index],
    );
  }
}
