import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController patientCondion = new TextEditingController();

  final _formData = GlobalKey<FormState>();

  Future<void> _saveForm() async {
    setState(() {
      numberOfPatiens = numberOfPatiens + 1;
      _isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('Patient')
          .doc('Patient$numberOfPatiens')
          .set({
        'Name': patientName.text,
        'Surname': patientSurname.text,
        'Condition': patientCondion.text,
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
        title: Text('Add Patients'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                ),
                Form(
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
                              return 'Please enter valid Name';
                            }
                            return null;
                          },
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
                            if (value == null) {
                              return 'Please enter valid Name';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          controller: patientCondion,
                          decoration: InputDecoration(labelText: 'Condition'),
                          keyboardType: TextInputType.name,
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
    );
  }
}
