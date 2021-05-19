import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      title: 'Cloud Patient Management',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'Cloud Patient Management'),
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
        body: Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 40.0),
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
                Text("Cloud Patient Management",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Sign In",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                  ),

                  textAlign: TextAlign.left,
                ),
                Text("Welcome back! Nice to see you again"),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Email",
                  style: TextStyle(
                      fontSize: 15.0,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: emailController,

                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Password",
                  style: TextStyle(
                    fontSize: 15.0,
                  color: Colors.blue,),
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = false;
                  });
                  await emailSignIn(emailController.text, passwordController.text);
                },
                child: _isLoading ? Text("Sign In",
                  style: TextStyle(
                    color: Colors.white
                ),)
                    : CircularProgressIndicator(),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
                ),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    ));
  }
  emailSignIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    setState(() {
      _isLoading = true;
    });
    //Navigator.pushNamed(context, "PatientList");
  }
}
