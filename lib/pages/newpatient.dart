import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPatient extends StatefulWidget {
  const NewPatient({Key? key});

  @override
  State<NewPatient> createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {

  String uid = " ";
  bool isLoading = false;
  late String prediction = '';
  final ImagePicker picker = ImagePicker();
  File? _image;


  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_uid = prefs.getString('uid') ?? '';
    setState(() {
      uid = user_uid;
    });
  }


  //show popup dialog
  void myAlert() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 40),
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 40),
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }



  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _companionController = TextEditingController();
  final TextEditingController _His_NumberController = TextEditingController();
  final TextEditingController _His_AddressController = TextEditingController();

  Future<void> _submit() async {
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .add({
        'name': _nameController.text,
        'birth': _birthController.text,
        'number': _numberController.text,
        'companion': _companionController.text,
        'His_Number': _His_NumberController.text,
        'His_Address': _His_AddressController.text,
        'gender': _selectGender,
        'doctor_uid': uid,
        'rates': {
          'Temperature': "0",
          'blood': "0",
          'glucose': "0",
        }
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Done')));
    } on FirebaseFirestore catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e as String)));
    }
  }


  String _selectGender = "Male";
  int _selectedItem = 0;
  final TextStyle _activeTabColor = TextStyle(color: Colors.deepPurpleAccent);
  final TextStyle _inactiveTabColor = TextStyle(color: Colors.grey);


  void runPhoto() {
    _image == null ? Icon(Icons.abc) : FileImage(_image!);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            TabBar(
              onTap: (value) {
                setState(() {
                  _selectedItem = value;
                });
              },
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.deepPurpleAccent,
              tabs: [
                Tab(
                  child: Text(
                    "Scan",
                    style:
                    _selectedItem == 0 ? _activeTabColor : _inactiveTabColor,
                  ),
                ),
                Tab(
                  child: Text(
                    "Add new patient",
                    style:
                    _selectedItem == 1 ? _activeTabColor : _inactiveTabColor,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Upload your image",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        DottedBorder(
                          dashPattern: [45],
                          color: Colors.deepPurpleAccent,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: _image != null
                                  ? DecorationImage(
                                  image: FileImage(_image!),
                                  fit: BoxFit.cover)
                                  : null,
                            ),
                            child: _image == null
                                ? IconButton(
                                  icon: Icon(
                              Icons.add,
                              color: Colors.deepPurpleAccent,
                            ), onPressed: () {
                                    myAlert();
                            },
                                )
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          onPressed: () {
                            setState(() {
                            uploadImageToServer(_image!);
                            });
                          },
                          text: "Scan",
                        ),
                        SizedBox(
                          height: 20
                        ),
                        Container(
                          child:
                              prediction == ''
                                  ? const Center()
                                  : Visibility(
                                visible: prediction != null,
                                child: Text(
                                  prediction,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: _nameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'please enter patient name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter patient name",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.datetime,
                                    controller: _birthController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'please enter your Date of birth ';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "MM/DD/YYYY",
                                      labelText: "Enter Date of birth",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _numberController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'please enter your number';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter phone number",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: _companionController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'please enter Patient companion';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter Patient companion",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _His_NumberController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'please enter his phone';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(

                                      hintText: "Enter His Phone",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: _His_AddressController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'please enter  his address';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter His Address",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                    ),
                                  ),
                                ],
                              )),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  title: Text(
                                    'Male',
                                    style: TextStyle(
                                        color: _selectGender == "Male"
                                            ? Colors.deepPurpleAccent
                                            : Colors.grey),
                                  ),
                                  activeColor: Colors.deepPurpleAccent,
                                  value: "Male",
                                  groupValue: _selectGender,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectGender = newValue!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  title: Text(
                                    'Female',
                                    style: TextStyle(
                                        color: _selectGender == "Female"
                                            ? Colors.deepPurpleAccent
                                            : Colors.grey),
                                  ),
                                  activeColor: Colors.deepPurpleAccent,
                                  value: "Female",
                                  groupValue: _selectGender,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectGender = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          CustomButton(
                            text: "Add patient",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                return _submit();
                              }
                            },
                          )
                        ],
                      ),
                    ),

                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  // We can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var pickedImage = await picker.pickImage(source: media);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future uploadImageToServer(File imageFile) async {
    if (kDebugMode) {
      print("Attempting to connect to server......");
    }
    var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.2:9874/predictApi')
    );
    if (kDebugMode) {
      print("Connection established.");
    }
    // Add the image file to the request
    request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path));

    // Send the request
    var response = await request.send();

    // Check the response status code
    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
    } else {
      print('Image upload failed with status code ${response.statusCode}');
    }

    // Parse the JSON response
    final responseJson = await response.stream.bytesToString().then((value) => json.decode(value));
    var pred = responseJson['prediction'];
    setState(() {
      prediction = pred;
    });
    print(prediction);
  }
}