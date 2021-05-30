import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_patient_management/Screens/addPatientScreen.dart';
import 'package:flutter/material.dart';
import 'patientDetailScreen.dart';

class ManagePatients extends StatefulWidget {
  @override
  _ManagePatientsState createState() => _ManagePatientsState();
}

class _ManagePatientsState extends State<ManagePatients> {
  @override
  Widget build(BuildContext context) {
    int numberOfItems = 0;

    return Scaffold(
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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 10,
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
                    ),
                    Text(
                      "Manage Patients",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context)
                          .pushNamed(PatientAddScreen.routeName),
                      child: Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_rounded,
                      ),
                      Text('Search'),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Patients')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator.adaptive();
                    }
                    var patientData = snapshot.data.docs;
                    numberOfItems = patientData.length;
                    print(numberOfItems);

                    return Padding(
                      padding: EdgeInsets.all(0.0),
                      //width: deviceConfig.width - 150,
                      //height: deviceConfig.height - 40,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: patientData.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                InkWell(
                                  splashColor: Theme.of(context).accentColor,
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      PatientDetailScreen.routeName,
                                      arguments: patientData[i]
                                          .data()['Name']
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
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Divider(
                                    indent: 0.1,
                                    endIndent: 0.1,
                                    height: 10,
                                    thickness: 2,
                                    color: Theme.of(context).primaryColor,
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
    );
  }
}
