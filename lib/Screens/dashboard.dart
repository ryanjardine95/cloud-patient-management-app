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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                  "This screen will serve as a statistical overview of each clinic"),
              Text("Number of Patients currently registered:"),
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
                    return Text("$numberOfItems");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
