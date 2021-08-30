import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_patient_management/Screens/patientDetailScreen.dart';
import 'package:cloud_patient_management/widgets/reportForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddPatientReport extends StatefulWidget {
  final patientId;
  final patientName;
  final patientSurname;
  AddPatientReport({
    required this.patientName,
    required this.patientSurname,
    required this.patientId,
  });
  @override
  _AddPatientReportState createState() => _AddPatientReportState();
}

class _AddPatientReportState extends State<AddPatientReport> {
  bool _hasChosen = false;
  bool _isLoading = false;
  int _counter = 0;
  void _generateRandomNumber() {
    var random = new Random();
    setState(() {
      _counter = random.nextInt(100);
    });
  }

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

    _generateRandomNumber();
    print(_counter);
  }

  List<AssetEntity> image = [];
  bool isChosen = false;

  Future<void> pickAssets() async {
    await AssetPicker.pickAssets(
      context,
      textDelegate: EnglishTextDelegate(),
    ).then((value) => value!.forEach((element) {
          image.add(element);
          setState(() {
            isChosen = true;
          });
        }));
  }

  final List<String> listUrls = [];

  Future<void> _saveImage() async {
    int index = image.length;

    setState(() {
      _isLoading = true;
    });
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('patients')
          .child('${widget.patientId}/$_counter');
      // ignore: unused_local_variable
      AssetEntity eleId =
          new AssetEntity(id: '', typeInt: 5, width: 5, height: 5);
      await Future.wait(image.map((element) async {
        setState(() {
          eleId = element;
        });
        final file = await element.file;
        final refPut = ref.child('$element$index');
        await refPut.putFile(File(file!.path));
      }));
      final ListResult listData =
          await ref.list(ListOptions(maxResults: index));

      await Future.wait(listData.items.map((e) async {
        await e.getDownloadURL().then((value) => listUrls.add(value));
      }));
      await FirebaseFirestore.instance
          .collection(result)
          .doc(result)
          .collection('Patients')
          .doc(
            '${widget.patientId}',
          )
          .collection('File')
          .doc(DateTime.now().toString())
          .set({
        'Url': listUrls,
        'Author': FirebaseAuth.instance.currentUser!.email,
        'Time': '${DateTime.now()}',
      });
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushNamed(
        PatientDetailScreen.routeName,
        arguments: widget.patientId.toString(),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Padding(
                        padding: EdgeInsets.all(39),
                      ),
                      Center(
                        child: Text('Add next Page to File'),
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
                      Padding(padding: EdgeInsets.all(65)),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _hasChosen = true;
                            });
                          },
                          child: Text(
                            'Page Template',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Or'),
                      IconButton(
                          iconSize: 100,
                          icon: Icon(Icons.image),
                          onPressed: () => pickAssets()),
                      isChosen
                          ? ListView.builder(
                              itemCount: image.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, i) => FutureBuilder(
                                    future: image[i].file,
                                    builder: (ctx, AsyncSnapshot<File?> file) {
                                      if (file.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator
                                            .adaptive();
                                      }
                                      final data = file.data!.absolute;
                                      return Container(
                                        margin: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        padding: EdgeInsets.only(
                                            left: 70,
                                            right: 70,
                                            top: 25,
                                            bottom: 25),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.elliptical(15, 65),
                                            ),
                                            border: Border.all()),
                                        child: Image.file(
                                          File(data.path),
                                        ),
                                      );
                                    },
                                  ))
                          : Center(),
                      TextButton(
                        onPressed: !isChosen ? () {} : _saveImage,
                        child: Text('Save Image'),
                      )
                    ],
                  ),
                )
              : ReportForm(
                  widget.patientId,
                ),
    );
  }
}
