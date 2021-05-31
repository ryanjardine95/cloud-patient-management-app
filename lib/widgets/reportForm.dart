import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportForm extends StatefulWidget {
  static const routeName = '/PatientAddScreen';
  final patientName;
  ReportForm(this.patientName);
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  int numberOfPatiens = 0;

  bool _isLoading = false;
  TextEditingController patientComplaint = new TextEditingController();
  TextEditingController patientExamination = new TextEditingController();
  TextEditingController patientTests = new TextEditingController();
  TextEditingController patientAssement = new TextEditingController();
  TextEditingController patientPlan = new TextEditingController();

  final _formData = GlobalKey<FormState>();

  bool isValid = false;

  Future<void> _saveForm() async {
    setState(() {
      numberOfPatiens = numberOfPatiens + 1;
      _isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc('${widget.patientName}')
          .update({
        'Complaint': patientComplaint.text,
        'Examination': patientExamination.text,
        'Tests': patientTests.text,
        'Plan': patientPlan.text,
        'Assesments': patientAssement.text
      });
    } catch (err) {}
    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? SingleChildScrollView(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
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
                            autovalidateMode: AutovalidateMode.always,
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter valid Name';
                              }
                              return null;
                            },
                            textAlignVertical: TextAlignVertical.center,
                            controller: patientAssement,
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
                            controller: patientComplaint,
                            decoration: InputDecoration(
                              labelText: 'Complaint',
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
                            decoration: InputDecoration(
                              labelText: 'Plan',
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
                            decoration: InputDecoration(
                              labelText: 'Tests',
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
                            decoration: InputDecoration(
                              labelText: 'Examination',
                            ),
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
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
                  )
                ],
              ),
            ),
    );
  }
}
