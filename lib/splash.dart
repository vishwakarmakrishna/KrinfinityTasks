//import 'dart:ui';

import 'dart:async';

import 'package:app/path/routes.dart';
// import 'package:app/xdi_phone12_pro_max1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => Timer(
          Duration(seconds: 3),
          () async {
            SharedPreferences emailprefs =
                await SharedPreferences.getInstance();

            var storedemailprefs = emailprefs.getString('email');

            if (FirebaseAuth.instance.currentUser != null ||
                storedemailprefs != null) {
              final String userid =
                  FirebaseAuth.instance.currentUser!.uid.toString();
              context.pushNamed(
                MyPath.todo,
                params: {
                  'id': userid,
                },
              );
            } else {
              context.pushNamed(MyPath.login);
            }
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final String applogo = 'assets/jpg/jpg.jpg';

    return Material(
      child: ZStack(
        [
          Image.asset(
            applogo,
            fit: BoxFit.cover,
            width: width / 2,
            height: height / 2,
          ).p16().centered(),
        ],
      ),
    );
  }
}
