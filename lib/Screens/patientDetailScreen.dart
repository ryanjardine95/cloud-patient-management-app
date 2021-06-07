import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_patient_management/Screens/addPatientReport.dart';
import 'package:cloud_patient_management/Screens/editPatientScreen.dart';
import 'package:cloud_patient_management/Screens/managePatientsScreen.dart';
import 'package:cloud_patient_management/widgets/NonListDetailWidget.dart';
import 'package:cloud_patient_management/widgets/PatietntfileViewer.dart';
import 'package:cloud_patient_management/widgets/detailWidget.dart';
import 'package:flutter/cupertino.dart';
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
  String patientComplaint = '';
  String patientExamination = '';
  String patientPlan = '';
  String patientTests = '';
  String patientAssesments = '';
  var patientComorbities = [];
  var patientTreatment = [];
  var patientfileUrl = [];

  bool _showBackToTopButton = false;

  ScrollController _scrollController = new ScrollController();
  String patientId = '';

  @override
  void initState() {
    super.initState();
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
        patientId = args == null ? '' : args.settings.arguments.toString();
      });
      print(patientId);
      _getPatients(patientId);
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
  Future<void> _getPatients(String patientIds) async {
    final patientData = await FirebaseFirestore.instance
        .collection('Patients')
        .doc(patientIds)
        .get();
    print(patientData['Surname']);
    setState(() {
      if (patientData['Assessments'] != null
          && patientData['Tests'] != null
          && patientData['Plan'] != null
          && patientData['Examination'] != null
          && patientData['Complaints'] != null){
        patientAssesments = patientData['Assessments'];
        patientTests = patientData['Tests'];
        patientPlan = patientData['Plan'];
        patientExamination = patientData['Examination'];
        patientComplaint = patientData['Complaints'];
      }else{
        patientAssesments = "No Data";
        patientTests = "No Data";
        patientPlan = "No Data";
        patientExamination = "No Data";
        patientComplaint = "No Data";
      }
      patientTreatment = List.from(patientData['Treatment']);
      patientName = patientData['Name'];
      patientSurname = patientData['Surname'];
      patientAge = patientData['Age'];
      patientComorbities = List.from(
        patientData['Comorbidities'],
      );
      patientfileUrl = List.from(patientData['Url']);
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceConfig = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.add),
      //       onPressed: () {},
      //     )
      //   ],
      //   centerTitle: true,
      //   toolbarHeight: 100,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(20),
      //   ),
      //   elevation: 50,
      //   titleTextStyle: TextStyle(
      //     fontSize: 15,
      //   ),
      //   leading: CircleAvatar(
      //     radius: 0.5,
      //     child: Icon(
      //       Icons.person,
      //     ),
      //   ),
      //   title: Text('$patientName $patientSurname, Age $patientAge'),
      // ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.face,
                            size: 60.0,
                          ),
                          Text('$patientName $patientSurname')
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Age",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$patientAge",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 40.0,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    settings:
                                        RouteSettings(name: '/PatientReport'),
                                    builder: (context) => AddPatientReport(
                                          patientName,
                                          patientSurname,
                                        ),
                                    fullscreenDialog: false)),
                            tooltip: "Add file",
                          ),
                          Text('Add File')
                        ],
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return EditPatientScreen(
                                      patientId: patientName,
                                    );
                                  },
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 40.0,
                            ),
                            color: Colors.blue,
                          ),
                          Text('Edit Patient'),
                        ],
                      ),
                    ],
                  ),
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
                  NonListDetailWidget(
                    patientData: patientComplaint,
                    sectionTitle: 'Complaint',
                  ),
                  NonListDetailWidget(
                    patientData: patientExamination,
                    sectionTitle: 'Examinations',
                  ),
                  NonListDetailWidget(
                    patientData: patientPlan,
                    sectionTitle: 'Plan',
                  ),
                  NonListDetailWidget(
                    patientData: patientAssesments,
                    sectionTitle: 'Assesments',
                  ),
                      NonListDetailWidget(
                    patientData: patientTests,
                    sectionTitle: 'Tests',
                  ),
                  Container(
                    height: deviceConfig.height / 2,
                    child: ListView.builder(
                      itemCount: patientfileUrl.length,
                      itemBuilder: (ctx, i) => Card(
                        child: Column(
                          children: [
                            Container(
                            child: patientfileUrl[i] != ''
                                ? PatientFileViewer(
                                    tag: '${patientfileUrl[i]} tag',
                                    url: patientfileUrl[i],
                                  )
                                : null,
                          ),
                          Text("Date and signature"),
                          ]
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _showBackToTopButton
          ? IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: _scrollToTop,
              tooltip: "back up",
            )
          : IconButton(
              icon: Icon(Icons.keyboard_return),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagePatients()),
                );
              }),
    );
  }
}
