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
        height: deviceConfig.height / 6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                sectionTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50, ),
                child: ListView.builder(
                  itemCount: patientData.length,
                  itemBuilder: (context, i) => Text(
                    patientData[i],
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
