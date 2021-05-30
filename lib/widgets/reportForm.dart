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
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 50,
        titleTextStyle: TextStyle(
          fontSize: 15,
        ),
        centerTitle: true,
        title: Text('Add Report'),
      ),
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
                    padding: EdgeInsets.all(15),
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
                            controller: patientAssement,
                            decoration: InputDecoration(labelText: 'Assesment'),
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
                            controller: patientComplaint,
                            decoration: InputDecoration(labelText: 'Complaint'),
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
                            controller: patientPlan,
                            decoration: InputDecoration(labelText: 'Plan'),
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
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter valid Name';
                              }
                              return null;
                            },
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
                  ElevatedButton(
                    onPressed: () => _saveForm(),
                    child: Text('Done'),
                  )
                ],
              ),
            ),
    );
  }
}
