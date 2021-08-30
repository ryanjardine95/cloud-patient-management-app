import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int numberOfItems = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.close),
        label: Text('Close'),
        onPressed: () => Navigator.pop(
          context,
        ),
      ),
      body: SafeArea(
        child: Container(
          height: 500,
          width: double.infinity,
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 25, bottom: 15, left: 0, right: 0),
                child: Text(
                  "Statistical overview of each clinic",
                  softWrap: true,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                width: 280,
                child: Divider(
                  thickness: 2,
                ),
              ),
              Container(
                  padding:
                      EdgeInsets.only(top: 25, bottom: 10, left: 0, right: 0),
                  child: Text(
                    "Number of Patients currently registered:",
                    style: TextStyle(fontSize: 15),
                  )),
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
                    return Container(
                        width: 300,
                        height: 120,
                        padding: EdgeInsets.only(
                            top: 10, bottom: 15, left: 130, right: 150),
                        child: Text(
                          "$numberOfItems",
                          style: TextStyle(
                              fontSize: 25, fontStyle: FontStyle.italic),
                        ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
