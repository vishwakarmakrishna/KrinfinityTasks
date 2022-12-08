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
              onPressed: () {
                context.pushNamed(MyPath.splash);
              },
              child: Text(
                'splash',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.pushNamed(MyPath.login);
              },
              child: Text(
                'login',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.pushNamed(MyPath.signup);
              },
              child: Text(
                'signup',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                context.pushNamed(MyPath.login);
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
