import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PatientDetailScreen extends StatefulWidget {
  static const routeName = '/patientDetailScreen';
  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  String patientName = ' ';
  String patientSurname = '';
  @override
  void initState() {
    String patitentId = '';
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        var args = ModalRoute.of(context);
        patitentId = args == null ? '' : args.settings.arguments.toString();
      });
      _getPatients(patitentId);
    });
  }

  Future<void> _getPatients(String patientId) async {
    final patientData = await FirebaseFirestore.instance
        .collection('Patient')
        .doc(patientId)
        .get();
    setState(() {
      patientName = patientData['Name'];
      patientSurname = patientData['Surname'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(patientName),
        ),
        body: Center(
          child: Text(patientSurname),
        ));
  }
}
