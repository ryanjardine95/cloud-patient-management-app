import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_patient_management/Screens/addPatientScreen.dart';
import 'package:cloud_patient_management/Screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'patientDetailScreen.dart';

class ManagePatients extends StatefulWidget {
  @override
  _ManagePatientsState createState() => _ManagePatientsState();
}

class _ManagePatientsState extends State<ManagePatients> {
  bool _isSearching = false;
  @override
  Widget build(BuildContext context) {
    int numberOfItems = 0;
    TextEditingController searchController = new TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   // shape: RoundedRectangleBorder(
      //   //   borderRadius: BorderRadius.circular(20),
      //   // ),
      //   // elevation: 50,
      //   // titleTextStyle: TextStyle(
      //   //   fontSize: 15,
      //   // ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.add),
      //       onPressed: () {
      //         Navigator.of(context).pushNamed(PatientAddScreen.routeName,
      //             arguments: numberOfItems);
      //       },
      //     ),
      //   ],
      //   centerTitle: true,
      //   title: Text('Manage Patients'),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Text(
                          "Dashboard",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 15.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()));
                        },
                      ),
                      Text(
                        "Manage Patients",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(PatientAddScreen.routeName),
                          child: Icon(
                            Icons.add,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: TextFormField(
                              // onTap: (){
                              //   setState(() {
                              //     _isSearching = true;
                              //   });
                              // },
                              controller: searchController,
                              validator: (value) {
                                if (value == null || value.length != 13) {
                                  return "Please enter 13 digit id number";
                                } else {
                                  return null;
                                }
                              },
                              //initialValue: "Search ${Icons.search_rounded}",
                              decoration: InputDecoration(
                                hintText: "Search patient ID number here",
                              ),
                              //controller: searchController,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSearching = true;
                                });
                                if (FirebaseFirestore.instance
                                        .collection('Patients')
                                        // ignore: unnecessary_null_comparison
                                        .doc(searchController.value
                                            .toString()) ==
                                    null) {
                                } else {
                                  Navigator.of(context).pushNamed(
                                      PatientDetailScreen.routeName,
                                      arguments: searchController.text);
                                }
                                setState(() {
                                  _isSearching = false;
                                });
                              },
                              icon: Icon(Icons.search_rounded),
                            ),
                          ),
                        ),
                      ),
                    ]),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Patients')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator.adaptive();
                      }
                      var patientData = snapshot.data!.docs;
                      numberOfItems = patientData.length;
                      print(numberOfItems);

                      return _isSearching
                          ? CircularProgressIndicator()
                          : Padding(
                              padding: EdgeInsets.all(0.0),
                              //width: deviceConfig.width - 150,
                              //height: deviceConfig.height - 40,
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: patientData.length,
                                  itemBuilder: (context, i) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          splashColor:
                                              Theme.of(context).accentColor,
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              PatientDetailScreen.routeName,
                                              arguments: patientData[i]
                                                  .data()['ID']
                                                  .toString(),
                                            );
                                          },
                                          child: ListTile(
                                            title: Text(
                                              '${patientData[i].data()['Surname']}, ${patientData[i].data()['Name']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                              ),
                                            ),
                                            subtitle: Text(
                                                "${patientData[i].data()["ID"]}"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Divider(
                                            indent: 0.1,
                                            endIndent: 0.1,
                                            height: 10,
                                            thickness: 2,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            );
                    }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
      ),
    );
  }
}
