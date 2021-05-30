import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_patient_management/widgets/imagePicker.dart';
import 'package:cloud_patient_management/widgets/reportForm.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddPatientReport extends StatefulWidget {
  final patientName;
  final patientSurname;
  AddPatientReport(this.patientName, this.patientSurname);
  @override
  _AddPatientReportState createState() => _AddPatientReportState();
}

class _AddPatientReportState extends State<AddPatientReport> {
  bool _hasChosen = false;
  bool _templeate = true;
  bool _isLoading = false;
  bool _imagePicked = false;

  File _userImageFile = File('path');
  @override
  void initState() {
    super.initState();
    _getImageUrl();
  }

  void _pickedIMage(File image) {
    setState(() {
      _userImageFile = image;
      _imagePicked = true;
    });
  }

  var urls = [];

  Future<void> _getImageUrl() async {
    final data = await FirebaseFirestore.instance
        .collection('Patients')
        .doc('${widget.patientName}')
        .get();
    setState(() {
      urls = List.from(
        data['Url'],
      );
    });
  }

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
    final String stringUrl = '$data,';
    urls.addAll(
      stringUrl.split(',').toList(),
    );
    final List<dynamic> urL = urls;
    await FirebaseFirestore.instance
        .collection('Patients')
        .doc(
          '${widget.patientName}',
        )
        .update({'Url': urL});
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.patientName + " " + widget.patientSurname}\'s Report'),
      ),
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
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(),
                          onPressed: () {
                            setState(() {
                              _hasChosen = true;
                            });
                          },
                          child: Text('Page Template'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Or'),
                      SizedBox(
                        height: 10,
                      ),
                      ImagePickerClass(
                        _pickedIMage,
                      ),
                      TextButton(
                        onPressed: !_imagePicked ? () {} : _saveImage,
                        child: Text('Save Image'),
                      )
                    ],
                  ),
                )
              : ReportForm(
                  widget.patientName,
                ),
    );
  }
}
