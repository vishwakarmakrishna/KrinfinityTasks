import 'package:app/path/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Myhome extends StatelessWidget {
  final String userid;
  const Myhome({required this.userid});

  @override
  Widget build(BuildContext context) {
    var abc = userid;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(abc.toString()),
            ElevatedButton(
              onPressed: () =>
                  {Navigator.pushNamed(context, MyPath.splashPath)},
              child: Text(
                'splash',
              ),
            ),
            ElevatedButton(
              onPressed: () => {Navigator.pushNamed(context, MyPath.loginPath)},
              child: Text(
                'login',
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  {Navigator.pushNamed(context, MyPath.signupPath)},
              child: Text(
                'signup',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushNamed(context, MyPath.loginPath);
              },
              child: Text(
                'logout',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
