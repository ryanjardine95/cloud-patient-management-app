import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_patient_management/widgets/PatietntfileViewer.dart';
import 'package:cloud_patient_management/widgets/detailWidget.dart';
import 'package:flutter/material.dart';

class PatientDetailScreen extends StatefulWidget {
  static const routeName = '/patientDetailScreen';
  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  String patientName = ' ';
  String patientSurname = '';
  String patientAge = '';
  var patientComorbities = [];
  var patientTreatment = [];
  var patientfileUrl = [];

  bool _showBackToTopButton = false;

  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    String patitentId = '';
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });
    Future.delayed(Duration.zero, () {
      setState(() {
        var args = ModalRoute.of(context);
        patitentId = args == null ? '' : args.settings.arguments.toString();
      });
      _getPatients(patitentId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(100,
        duration: Duration(seconds: 3), curve: Curves.linear);
  }

  var i = 0;
  Future<void> _getPatients(String patientId) async {
    final patientData = await FirebaseFirestore.instance
        .collection('Patient')
        .doc(patientId)
        .get();
    setState(() {
      patientName = patientData['Name'];
      patientSurname = patientData['Surname'];
      patientAge = patientData['Age'];
      patientComorbities = List.from(
        patientData['Comorbidities'],
      );
      patientTreatment = List.from(patientData['Treatment']);
      patientfileUrl = List.from(patientData['Url']);
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceConfig = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
        centerTitle: true,
        toolbarHeight: 100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 50,
        titleTextStyle: TextStyle(
          fontSize: 15,
        ),
        leading: CircleAvatar(
          radius: 0.5,
          child: Icon(
            Icons.person,
          ),
        ),
        title: Text('$patientName $patientSurname, Age $patientAge'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(
              thickness: 2,
            ),
            DetailWidget(
              patientData: patientComorbities,
              sectionTitle: 'Comorbidities',
            ),
            DetailWidget(
              patientData: patientTreatment,
              sectionTitle: 'Treatment',
            ),
            Container(
              height: deviceConfig.height / 2,
              child: ListView.builder(
                itemCount: patientfileUrl.length,
                itemBuilder: (ctx, i) => Container(
                  child: PatientFileViewer(
                    url: patientfileUrl[i],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _showBackToTopButton
          ? IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: _scrollToTop,
            )
          : IconButton(icon: Icon(Icons.circle), onPressed: () {}),
    );
  }
}
