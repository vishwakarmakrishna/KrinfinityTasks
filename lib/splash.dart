//import 'dart:ui';

import 'dart:async';

import 'package:app/path/routes.dart';
import 'package:app/todo.dart';
// import 'package:app/xdi_phone12_pro_max1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () async {
        SharedPreferences emailprefs = await SharedPreferences.getInstance();

        var storedemailprefs = emailprefs.getString('email');

        if (FirebaseAuth.instance.currentUser != null ||
            storedemailprefs != null) {
          final String userid =
              FirebaseAuth.instance.currentUser!.uid.toString();

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Todo(userid: userid)),
            //  MaterialPageRoute(builder: (context) => TodoNew()),
          );
        } else {
          Navigator.pushNamed(context, MyPath.loginPath);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.ac_unit,
              size: 100,
            ),
          ),
        ],
      ),
    );
  }
}
