import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_patient_management/Screens/addPatientReport.dart';
import 'package:cloud_patient_management/Screens/editPatientScreen.dart';
import 'package:cloud_patient_management/widgets/detailWidget.dart';
import 'package:cloud_patient_management/widgets/fullScreenFileViewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:shared_preferences/shared_preferences.dart';

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
  String? patientEncryptedData;
  String unencryptedData = '';
  var patientComorbities = [];
  var patientTreatment = [];
  List<dynamic> patientFile = [];

  bool _showBackToTopButton = false;

  ScrollController _scrollController = new ScrollController();
  String patientId = '';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String result = '';
  Future<void> getDB() async {
    final data = await _prefs;
    result = data.getString('HospitalId')!;
  }

  @override
  void initState() {
    super.initState();
    getDB();

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
        patientId = args == null
            ? 'no valid patient'
            : args.settings.arguments.toString();
      });
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
        .collection(result)
        .doc(result)
        .collection('Patients')
        .doc(patientIds)
        .get();
    final fileData = await FirebaseFirestore.instance
        .collection(result)
        .doc(result)
        .collection('Patients')
        .doc(patientIds)
        .collection("File")
        .get();
    setState(() {
      // if (patientData['Assessments'] != null
      //     && patientData['Tests'] != null
      //     && patientData['Plan'] != null
      //     && patientData['Examination'] != null
      //     && patientData['Complaints'] != null){
      //   patientAssesments = patientData['Assessments'];
      //   patientTests = patientData['Tests'];
      //   patientPlan = patientData['Plan'];
      //   patientExamination = patientData['Examination'];
      //   patientComplaint = patientData['Complaints'];
      // }else{
      //   patientAssesments = "No Data";
      //   patientTests = "No Data";
      //   patientPlan = "No Data";
      //   patientExamination = "No Data";
      //   patientComplaint = "No Data";
      // }
      patientEncryptedData = patientData['TestEncrypt'];
      patientTreatment = List.from(patientData['Treatment']);
      patientName = patientData['Name'];
      patientSurname = patientData['Surname'];
      patientAge = patientData['Age'];
      patientComorbities = List.from(
        patientData['Comorbidities'],
      );
      patientFile = List.from(fileData.docs);
    });
    await unencryptData();
  }

  Future<void> unencryptData() async {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    unencryptedData = encrypter.decrypt64(patientEncryptedData!, iv: iv);
  }

  @override
  Widget build(BuildContext context) {
    var deviceConfig = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
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
                        Text(
                          '$patientName + $patientSurname',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        )
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
                              size: 30.0,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddPatientReport(
                                    patientName: patientName,
                                    patientSurname: patientSurname,
                                    patientId: patientId,
                                  ),
                                ))),
                        Text('Add to File')
                      ],
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return EditPatientScreen(
                                    patientId: patientId,
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
                Container(
                  height: deviceConfig.height / 2,
                  child: ListView.builder(
                    reverse: true,
                    itemCount: patientFile.length,
                    itemBuilder: (context, i) {
                      return Card(child: () {
                        if (patientFile[i]['Url'] == "") {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Patient's complaint:",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${patientFile[i]['Complaints']}",
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Patient's Examination:",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("${patientFile[i]['Examination']}"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Patient's Tests:",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("${patientFile[i]['Tests']}"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Patient's Assessments:",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("${patientFile[i]['Assessments']}"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Patient's Plan:",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("${patientFile[i]['Plan']}"),
                                  ],
                                ),
                              ),
                              Text(
                                "Author: ${patientFile[i]['Author']}",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              Text(
                                "Time: ${patientFile[i]['Time']}",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text("Page $i"),
                            ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                patientFile[i]['Url'] == null
                                    ? CircularProgressIndicator()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: patientFile[i]['Url'].length,
                                        itemBuilder: (ctx, index) =>
                                            GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    FullScreenFileViewer(
                                                  tag: patientFile[i]["Url"]
                                                      [index],
                                                  url: patientFile[i]["Url"]
                                                      [index],
                                                ),
                                              )),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 3),
                                            ),
                                            child: Image(
                                                image:
                                                    CachedNetworkImageProvider(
                                              patientFile[i]["Url"][index],
                                            )),
                                          ),
                                        ),
                                      ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Author: ${patientFile[i]["Author"]}",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      "Time: ${patientFile[i]["Time"]}",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                Text("Page $i"),
                              ],
                            ),
                          );
                        }
                      }()
                          // Column(
                          //   children: [
                          //
                          //     Text((){
                          //       if(patientFile[i].get('Url') == ""){
                          //         return "${patientFile[i].get('Assessments')}, ${patientFile[i].get("Time")}";
                          //       }else{
                          //         return "${patientFile[i].get('Url')}";
                          //       }
                          //     }()),
                          //   //Text("${patientFile[i].get('Url')}"),
                          //   ]
                          // ),
                          );
                    },
                  ),
                ),
              ],
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
              onPressed: () {
                Navigator.pop(context);
              }),
    );
  }
}
