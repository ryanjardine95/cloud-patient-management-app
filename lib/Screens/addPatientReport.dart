import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_patient_management/Screens/patientDetailScreen.dart';
import 'package:cloud_patient_management/widgets/imagePicker.dart';
import 'package:cloud_patient_management/widgets/reportForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddPatientReport extends StatefulWidget {
  final patientId;
  final patientName;
  final patientSurname;
  AddPatientReport(this.patientName, this.patientSurname, this.patientId);
  @override
  _AddPatientReportState createState() => _AddPatientReportState();
}

class _AddPatientReportState extends State<AddPatientReport> {
  bool _hasChosen = false;
  bool _isLoading = false;
  bool _imagePicked = false;

  File _userImageFile = File('path');

  // @override
  // void initState() {
  //   super.initState();
  //   _getImageUrl();
  // }

  void _pickedImage(File image) {
    setState(() {
      _userImageFile = image;
      _imagePicked = true;
    });
  }

  var urls = [];

  // Future<void> _getImageUrl() async {
  //   final data = await FirebaseFirestore.instance
  //       .collection('Patients')
  //       .doc('${widget.patientName}')
  //   .collection('Files')
  //       .get();
  //   setState(() {
  //     urls = List.from(
  //       data['Url'],
  //     );
  //   });
  // }

  Future<void> _saveImage() async {
    setState(() {
      _isLoading = true;
    });
    final ref = FirebaseStorage.instance
        .ref()
        .child('patients')
        .child(widget.patientName + 'jpg');

    await ref.putFile(_userImageFile);
    final String data = await ref.getDownloadURL();
    final String stringUrl = '$data';
    // urls.addAll(
    //   stringUrl.split(',').toList(),
    // );
    // final List<dynamic> urL = urls;
    await FirebaseFirestore.instance
        .collection('Patients')
        .doc(
          '${widget.patientId}',
        ).collection('File')
        .doc(DateTime.now().toString())
        .set({
      'Url': stringUrl,
      'Author': FirebaseAuth.instance.currentUser!.email,
       'Time': DateTime.now(),
    });
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushNamed(
      PatientDetailScreen.routeName,
      arguments: widget.patientId.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : !_hasChosen
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(39),
                      ),
                      Center(
                        child: Text('Add next Page to File'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 280,
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(65)),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _hasChosen = true;
                            });
                          },
                          child: Text(
                            'Page Template',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Or'),
                      ImagePickerClass(
                        _pickedImage,
                      ),
                      TextButton(
                        onPressed: !_imagePicked ? () {} : _saveImage,
                        child: Text('Save Image'),
                      )
                    ],
                  ),
                )
              : ReportForm(
                  widget.patientId,
                ),
    );
  }
}
