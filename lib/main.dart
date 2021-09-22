//import 'package:firebase_core/firebase_core.dart';

import 'package:app/myhome.dart';
import 'package:app/signup.dart';
import 'package:app/splash.dart';
import 'package:app/todo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app/path/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InPhoMeeT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'keep',
        primarySwatch: Colors.blue,
        accentColor: Colors.deepPurpleAccent[700],
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            initialRoute: MyPath.splashPath,
            routes: {
              MyPath.todoPath: (context) => Todo(userid: 'No'),
              MyPath.signupPath: (context) => Signup(),
              MyPath.loginPath: (context) => Login(),
              MyPath.splashPath: (context) => MySplash(),
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Error')),
    );
  }
}
