import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/pages/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPatient extends StatefulWidget {
  const MyPatient({Key? key}) : super(key: key);

  @override
  _MyPatientState createState() => _MyPatientState();
}

class _MyPatientState extends State<MyPatient> {
  String uid = " ";
  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_uid = prefs.getString('uid') ?? '';
    setState(() {
      uid = user_uid;
    });
  }

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('patients');
  late TextEditingController _searchController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    getData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Your Patients",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                suffixIcon: Transform.rotate(
                  angle: 50 * 6.1415926535 / 180,
                  child: Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 2, 4, 43),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
  stream: collection.where('doctor_uid', isEqualTo:uid)
                     .where('name', isGreaterThanOrEqualTo: _searchText)
                     .where('name', isLessThan: _searchText + 'z')
                     .snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
      // return Text('Something went wrong ${snapshot.error}');
      return TextFormField(
        initialValue: "${snapshot.error}",
      );
      
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text('Loading');
    }

    final filteredDocs = snapshot.data!.docs;

    if (filteredDocs.isEmpty) {
      return Text('No results found');
    } else {
      return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (BuildContext context, int index) {
            final document = filteredDocs[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Patient_Details(
                      document: document,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 7),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      collection.doc(document.id).delete();
                    },
                  ),
                  leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(Icons.person)),
                  title: Text(
                    document['name'].toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(document['birth']),
                ),
              ),
            );
          });
    }
  },
)
),
          ],
        ),
      ),
    );
  }
}
