import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_patient_management/Screens/patientDetailScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReportForm extends StatefulWidget {
  static const routeName = '/PatientAddScreen';
  final patientId;
  ReportForm(this.patientId);
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {

  int numberOfPatiens = 0;
  String? userEmail = FirebaseAuth.instance.currentUser!.email == null ? "" : FirebaseAuth.instance.currentUser!.email;
  bool _isLoading = false;
  TextEditingController patientComplaint = new TextEditingController();
  TextEditingController patientExamination = new TextEditingController();
  TextEditingController patientTests = new TextEditingController();
  TextEditingController patientAssement = new TextEditingController();
  TextEditingController patientPlan = new TextEditingController();


  final _formData = GlobalKey<FormState>();

  bool isValid = false;

  Future<void> _saveForm() async {
    print(widget.patientId.toString());
    setState(() {
      numberOfPatiens = numberOfPatiens + 1;
      _isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc('${widget.patientId}')
          .collection('File')
          .doc(DateTime.now().toString())
          .set({
        'Author': userEmail,
        'Time': "${DateTime.now()}",
        'Complaints': patientComplaint.text,
        'Examination': patientExamination.text,
        'Tests': patientTests.text,
        'Plan': patientPlan.text,
        'Assessments': patientAssement.text,
        'Url': "",
      });
    } catch (err) {}
    setState(() {
      _isLoading = false;
      Navigator.of(context).pushNamed(PatientDetailScreen.routeName, arguments: '${widget.patientId}');
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(39),
                    ),
                    Center(
                      child: Text(
                        'Add Report From Template',
                        style: TextStyle(fontSize: 15),
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
                      padding: EdgeInsets.all(20),
                    ),
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
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter valid Name';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              controller: patientComplaint,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Complaint',
                              ),
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter valid Name';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              controller: patientExamination,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Examination',
                              ),
                              keyboardType: TextInputType.multiline,
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
                              textInputAction: TextInputAction.next,
                              controller: patientTests,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Tests',
                              ),
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
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
                              controller: patientAssement,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Assesment',
                              ),
                              keyboardType: TextInputType.multiline,
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
                              controller: patientPlan,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Plan',
                              ),
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 10),
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
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}
