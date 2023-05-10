import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Patient_Details extends StatefulWidget {
  Patient_Details({ required this.document,});
  final DocumentSnapshot document;

  @override
  State<Patient_Details> createState() => _Patient_DetailsState();
}

class _Patient_DetailsState extends State<Patient_Details> {
  final TextEditingController _TemperatureController = TextEditingController();
  final TextEditingController _bloodController = TextEditingController();
  final TextEditingController _glucose_meterController =
      TextEditingController();

  void AddRates() {
    FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.document.id)
        .update({
      'rates': {
        'Temperature': _TemperatureController.text,
        'blood': _bloodController.text,
        'glucose': _glucose_meterController.text,
      },
      // وأي بيانات أخرى
    }).then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      print('Error adding data: $error');
    });
  }

   

  var primaryColor = Color.fromARGB(255, 61, 202, 148);
  primaryText() =>
      TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    String birthStr = "${widget.document["birth"]}";
    DateTime birthDate = DateFormat('dd/MM/yyyy').parse(birthStr);
    Duration difference = DateTime.now().difference(birthDate);
    int age = (difference.inDays / 365.25).floor();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ElevatedButton(
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
                Expanded(
                  child: Center(
                    child: Text(
                      "Patient Detials",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 15, 14, 68)),
                    ),
                  ),
                )
              ],
            ),
            Container(
              color: Colors.grey.withOpacity(0.2),
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 1,
                  )),
                  child: Image.asset(
                    "assets/patient_photo.png",
                  ),
                ),
                title: Text(
                  widget.document["name"],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: [
                    Text("$age Years"),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Image.asset(
                  "assets/medical.png",
                  width: 50,
                  height: 50,
                  color: primaryColor,
                ),
                Text(
                  "Personal info",
                  style: primaryText(),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/age.png",
                          width: 50,
                          height: 50,
                          color: primaryColor,
                        ),
                        Text("$age Years")
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 25)),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/genders.png",
                          width: 50,
                          height: 50,
                          color: primaryColor,
                        ),
                        Text(widget.document["gender"])
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 25)),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/calendar.png",
                          width: 50,
                          height: 50,
                          color: primaryColor,
                        ),
                        Text(widget.document["birth"])
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Image.asset(
                  "assets/heart-in-hands.png",
                  width: 50,
                  height: 50,
                  color: primaryColor,
                ),
                Text(
                  " Normal Rates",
                  style: primaryText(),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext) {
                                return AlertDialog(
                                  title: Text("Edit Rates"),
                                  actions: [
                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: _glucose_meterController,
                                              decoration: InputDecoration(
                                                hintText: "glucose Meter",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(10)),
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            TextFormField(
                                          controller: _bloodController,
                                          decoration: InputDecoration(
                                            hintText: "blood pressure gauge",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                            SizedBox(height: 10,),
                                        TextFormField(
                                          controller: _TemperatureController,
                                          decoration: InputDecoration(
                                            hintText: "Temperature",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                            SizedBox(height: 10,),
                                        Row(
                                          children: [
                                       CustomButton(
                                            onPressed: (){  Navigator.of(context).pop();},
                                            text: "Close"),
                                                Expanded(child: Container()),
                                               
                                                  CustomButton(
                                                onPressed: AddRates,
                                                text: "save"),
                                          ],
                                        )
                                            
                                          ],
                                        ),
                                      ),
                                    ),
                                 
                                  ],
                                );
                              });
                        },
                        child: Text(
                          "Edit",
                          style: primaryText(),
                        )),
                  ],
                ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/glucose-meter.png",
                          width: 50,
                          height: 50,
                        ),
                        Text(widget.document["rates"]["glucose"])
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 25)),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/blood-pressure-gauge.png",
                          width: 50,
                          height: 50,
                        ),
                        Text(widget.document["rates"]["blood"])
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 25)),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/Temperature-measuring.png",
                          width: 50,
                          height: 50,
                        ),
                        Text(widget.document["rates"]["Temperature"])
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Image.asset(
                  "assets/document.png",
                  width: 50,
                  height: 50,
                  color: primaryColor,
                ),
                Text(
                  "Medical Record",
                  style: primaryText(),
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      child: Icon(Icons.search)),
                  title: Text("Scan No.2"),
                  subtitle: Text("20, Feb 2023"),
                  trailing: Text("No Cancer"),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
