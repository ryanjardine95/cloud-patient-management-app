import 'package:cloud_patient_management/Screens/managePatientsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/patientDetailScreen.dart';
import 'Screens/addPatientScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloud Patient Management',
      theme:
          ThemeData(primarySwatch: Colors.grey, accentColor: Colors.blue),
      routes: {
        PatientDetailScreen.routeName: (ctx) => PatientDetailScreen(),
        PatientAddScreen.routeName: (ctx) => PatientAddScreen(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ManagePatients();
          } else {
            return MyHomePage(title: 'Cloud Patient Management');
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 100.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    child: Image.asset(
                      "assets/images/cloud.png",
                      height: 120,
                      width: 120,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Cloud Patient Management",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text("Welcome back! Nice to see you again"),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                controller: emailController,
              ),
              TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.blue,
                    )),
                controller: passwordController,
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = false;
                  });
                  await emailSignIn(
                      emailController.text, passwordController.text);
                },
                child: _isLoading
                    ? Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white),
                      )
                    : CircularProgressIndicator(),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
              ),
            ],
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    ));
  }

  emailSignIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    setState(() {
      _isLoading = true;
    });
    //Navigator.pushNamed(context, "PatientList");
  }
}
