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
            title: 'KrInfinite Tasks',
            debugShowCheckedModeBanner: false,
            routes: {
              MyPath.todoPath: (context) => Material(child: Todo(userid: 'No')),
              MyPath.signupPath: (context) => Material(child: Signup()),
              MyPath.loginPath: (context) => Material(child: Login()),
              MyPath.splashPath: (context) => Material(child: MySplash()),
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
    return Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(child: Text('Error')),
    );
  }
}
