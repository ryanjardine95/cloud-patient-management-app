import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_patient_management/Screens/imagePicker.dart';
import 'package:cloud_patient_management/Screens/managePatientsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PatientAddScreen extends StatefulWidget {
  static const routeName = '/PatientAddScreen';
  @override
  _PatientAddScreenState createState() => _PatientAddScreenState();
}

class _PatientAddScreenState extends State<PatientAddScreen> {
  int numberOfPatiens = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        var args = ModalRoute.of(context);
        numberOfPatiens = args == null ? 0 : args.settings.arguments as int;
      });
    });
  }

  bool _isLoading = false;
  TextEditingController patientName = new TextEditingController();
  TextEditingController patientSurname = new TextEditingController();
  TextEditingController patientAge = new TextEditingController();
  TextEditingController patientcomorbidities = new TextEditingController();
  TextEditingController patientTreatment = new TextEditingController();
  TextEditingController patientId = new TextEditingController();
  List<String> patientcomorbiditiesList = [];
  List<String> patientTreatmentList = [];

  final _formData = GlobalKey<FormState>();

  File _userImageFile = File('path');
  void _pickedImage(File image) {
    setState(() {
      _userImageFile = image;
    });
  }

  bool isValid = false;

  Future<void> _saveForm() async {
    setState(() {
      patientcomorbiditiesList = patientcomorbidities.text.split(',').toList();
      patientTreatmentList = patientTreatment.text.split(',').toList();

      numberOfPatiens = numberOfPatiens + 1;
      _isLoading = true;
    });
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('patients')
          .child(patientName.text + 'jpg');

      await ref.putFile(_userImageFile);
      final String data = await ref.getDownloadURL();
      final String url = data;

      await FirebaseFirestore.instance
          .collection('Patients')
          .doc('${patientId.text.toString()}')
          .set({
        'Name': patientName.text,
        'Surname': patientSurname.text,
        'PatientId': 'Patient$numberOfPatiens',
        'Age': patientAge.text.toString(),
        'Comorbidities': patientcomorbiditiesList,
        'Treatment': patientTreatmentList,
        "ID": patientId.text.toString(),
      });
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc('${patientId.text.toString()}')
          .collection("File")
          .doc("${DateTime.now()}")
          .set({
        'Author': FirebaseAuth.instance.currentUser!.email,
        "Time": DateTime.now().toString(),
        'Url': url as List,
      });
    } catch (err) {}
    setState(() {
      _isLoading = false;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ManagePatients()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? SafeArea(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Add Patient',
                        style: TextStyle(fontSize: 20),
                      ),
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
                    Padding(
                      padding: EdgeInsets.all(15),
                    ),
                    ImagePickerClass(_pickedImage),
                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: _formData,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter valid Name';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              controller: patientName,
                              decoration: InputDecoration(labelText: 'Name'),
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter valid Surname';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              controller: patientSurname,
                              decoration: InputDecoration(labelText: 'Surname'),
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.length < 13) {
                                  return 'Please enter valid 13 digit ID Number';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              controller: patientId,
                              decoration:
                                  InputDecoration(labelText: 'ID Number'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter valid Name';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              controller: patientAge,
                              decoration: InputDecoration(labelText: 'Age'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter valid Name';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              controller: patientcomorbidities,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Comorbidities',
                                hintText: 'Please seperate using commas',
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter valid Name';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              controller: patientTreatment,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Treatments',
                                hintText: 'Please seperate using commas',
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 90, vertical: 8),
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                      onPressed: () => _saveForm(),
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text("Please add an Image to start a patients file"),
                  ],
                ),
              ),
            ),
    );
  }
}
