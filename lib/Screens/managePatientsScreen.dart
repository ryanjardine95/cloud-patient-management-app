import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'patientDetailScreen.dart';

class ManagePatients extends StatefulWidget {
  @override
  _ManagePatientsState createState() => _ManagePatientsState();
}

class _ManagePatientsState extends State<ManagePatients> {
  @override
  Widget build(BuildContext context) {
    var devieConfig = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 50,
        titleTextStyle: TextStyle(
          fontSize: 15,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        title: Text('Manage Patients'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: devieConfig.height / 20),
            Text('#willBeASearchBar'),
            SizedBox(height: devieConfig.height / 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 110),
              width: devieConfig.width,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Patient')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator.adaptive();
                    }

                    var patientData = snapshot.data.docs;

                    return SizedBox(
                      width: devieConfig.width - 150,
                      height: devieConfig.height - 100,
                      child: ListView.builder(
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
                                          .data()['PatientId']
                                          .toString(),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(
                                      '${patientData[i].data()['Surname']}, ${patientData[i].data()['Name']}',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Divider(
                                    indent: 0.1,
                                    endIndent: 0.1,
                                    height: 45,
                                    thickness: 2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            );
                          }),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
