import 'package:flutter/material.dart';

class DetailWidget extends StatelessWidget {
  final patientData;
  final sectionTitle;
  DetailWidget({this.patientData, this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    var deviceConfig = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        height: deviceConfig.height / 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sectionTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: patientData.length,
                itemBuilder: (context, i) => Text(
                  patientData[i],
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 3,
            ),
          ],
        ),
      ),
    );
  }
}
