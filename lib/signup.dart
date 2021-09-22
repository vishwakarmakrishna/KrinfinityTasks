import 'package:app/backend/auth.dart';
import 'package:app/myhome.dart';
import 'package:app/todo.dart';
import 'package:email_validator/email_validator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/path/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

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
  var password = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

// Height (without SafeArea)
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

// Height (without status bar)
    double height2 = height - padding.top;

// Height (without status and toolbar)
    double height3 = height - padding.top - kToolbarHeight;
    final String applogo = 'assets/svg/brandnewtsvg.svg';
    final Widget appLogoSvg = SvgPicture.asset(applogo,
        width: width * 0.08, semanticsLabel: 'Acme Logo');

    return Material(
      color: Colors.blueAccent,
      child: Form(
        key: _formKey,
        child: ZStack([
          VStack([
            CupertinoFormSection.insetGrouped(
              margin: EdgeInsets.all(12),
              header: ZStack(
                [
                  Row(
                    children: [
                      'Create new user'
                          .text
                          .color(Colors.blueAccent)
                          .size(width * 0.06)
                          .extraBold
                          .letterSpacing(1)
                          .makeCentered(),
                    ],
                  ),
                ],
                alignment: AlignmentDirectional.center,
              ),
              footer: ZStack(
                [
                  Column(
                    children: [
                      Material(
                        color: Colors.blueAccent,
                        borderRadius:
                            BorderRadius.circular(changeButton ? 30 : 10),
                        child: InkWell(
                            splashColor: Colors.white,
                            focusColor: Colors.white,
                            highlightColor: Colors.white,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              width: changeButton ? width * 0.5 : width * 0.9,
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
                            onTap: () =>
                                Navigator.pushNamed(context, MyPath.loginPath)),
                      )
                    ],
                  ),
                ],
                alignment: AlignmentDirectional.center,
              ),
              children: [
                CupertinoFormRow(
                  prefix: Text('Username'),
                  child: CupertinoTextFormFieldRow(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    placeholder: 'Enter Username',
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username cannot be Empty';
                      } else if (value.length < 6) {
                        return 'Must be atleast 6 characters long';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('Email'),
                  child: CupertinoTextFormFieldRow(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    placeholder: 'Enter Email',
                    onChanged: (email) {
                      setState(() {});
                    },
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Email cannot be Empty'
                            : null,
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('Password'),
                  child: CupertinoTextFormFieldRow(
                    controller: _passwordController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    placeholder: 'Enter password',
                    onChanged: (password) {
                      setState(() {
                        password = this.password;
                      });
                    },
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Password cannot be empty';
                      } else if (password.length < 6) {
                        return 'Must be atleast 6 characters long';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('Confirm'),
                  child: CupertinoTextFormFieldRow(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    placeholder: 'Re-enter password',
                    onChanged: (confirmpassword) {
                      setState(() {});
                    },
                    validator: (confirmpassword) {
                      if (confirmpassword != null) {
                        if (confirmpassword.isEmpty) {
                          return "Password cannot be empty";
                        } else if (password.length < 6) {
                          return 'Must be atleast 6 characters long';
                        } else if (confirmpassword != password) {
                          return "Password does not match";
                        }
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ).box.rounded.makeCentered()
          ]).objectCenter(),
        ]),
      ),
    );
  }
}
