import 'package:flutter/material.dart';

class NonListDetailWidget extends StatelessWidget {
  final patientData;
  final sectionTitle;
  NonListDetailWidget({this.patientData, this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    var deviceConfig = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            sectionTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: deviceConfig.height / 5,
            child: Text(
              patientData,
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue
              ),
            ),
          ),
          Divider(
            thickness: 3,
          )
        ],
      ),
    );
  }
}
