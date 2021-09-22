import 'package:app/backend/auth.dart';
import 'package:app/myhome.dart';
import 'package:app/todo.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/path/routes.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool changeButton = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  // bool _success = false;
  // String _userEmail = "";
  final _formKey = GlobalKey<FormState>();
  var pass = "";

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.green,
        child: Column(children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                SizedBox(
                  height: 200,
                ),
                SizedBox(
                  height: 40,
                  child: Text(
                    'Todo App',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Column(children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: "Username"),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username cannot be Empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email"),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username cannot be Empty';
                        } else if (!value.contains('@gmail.com')) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Password"),
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (value.length < 6) {
                            return "Password length should be atleast 6";
                          }
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration:
                          InputDecoration(labelText: "Confirm Password"),
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (value != pass) {
                            return "Password does not match";
                          }
                        } else {
                          return null;
                        }
                      },
                    )
                  ]),
                ),
                SizedBox(
                  height: 20,
                ),
                Material(
                  color: Colors.pink[600],
                  borderRadius: BorderRadius.circular(changeButton ? 30 : 10),
                  child: InkWell(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: changeButton ? 50 : 150,
                        height: 50,
                        alignment: Alignment.center,
                        child: changeButton
                            ? Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 40,
                              )
                            : Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      // onTap:
                      // ()=>{},
                      onTap: () async {
                        String userid = await signup(
                          email: _emailController.text,
                          password: _passwordController.text,
                          username: _usernameController.text,
                        );
                        if (userid != 'No') {
                          print(FirebaseAuth.instance.currentUser!.uid);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Todo(
                                      userid: userid,
                                    )),
                          );
                        }
                      }),
                ),
              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: InkWell(
              child: const Text(
                'Already Registered?',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                ),
              ),
              onTap: () => Navigator.pushNamed(context, MyPath.loginPath),
            ),
          )
        ]));
  }
}
