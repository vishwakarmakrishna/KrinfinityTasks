import 'package:app/backend/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:app/path/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // moveToHome(BuildContext context) async {
  //   if (_formKey.currentState!.validate()) {}
  // }

  Widget build(BuildContext context) {
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

// // Height (without SafeArea)
//     var padding = MediaQuery.of(context).padding;
//     double height1 = height - padding.top - padding.bottom;

// // Height (without status bar)
//     double height2 = height - padding.top;

// // Height (without status and toolbar)
//     double height3 = height - padding.top - kToolbarHeight;
//     final String applogo = 'assets/svg/brandnewtsvg.svg';
    // final Widget appLogoSvg =
    //     SvgPicture.asset(applogo, width: width, semanticsLabel: 'Acme Logo');

    return Material(
      color: Colors.blueAccent,
      child: Form(
        key: _formKey,
        child: ZStack(
          [
            VStack(
              [
                CupertinoFormSection.insetGrouped(
                  margin: EdgeInsets.all(12),
                  header: ZStack(
                    [
                      Row(
                        children: [
                          'Login'
                              .text
                              .extraBold
                              .color(Colors.blueAccent)
                              .size(width * 0.06)
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
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                              onTap: () async {
                                final form = _formKey.currentState!;

                                String userid = await login(
                                    _emailController.text,
                                    _passwordController.text);

                                if (userid != 'No' && userid.isNotEmpty) {
                                  context.pushNamed(
                                    MyPath.todo,
                                    params: {
                                      'id': userid,
                                    },
                                  );

                                  if (form.validate()) {
                                    setState(() {
                                      changeButton = true;
                                    });
                                    await Future.delayed(Duration(seconds: 1));
                                    await Fluttertoast.showToast(
                                        msg: "Sucessfully logged in",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    context.pushNamed(
                                      MyPath.todo,
                                      params: {
                                        'id': userid,
                                      },
                                    );
                                    setState(() {
                                      changeButton = false;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: InkWell(
                              child: const Text(
                                'Not Registered?',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () {
                                context.pushNamed(MyPath.signup);
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                    alignment: AlignmentDirectional.center,
                  ),
                  children: [
                    CupertinoFormRow(
                      prefix: Text('Email'),
                      child: CupertinoTextFormFieldRow(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        placeholder: 'Enter Email',
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
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        placeholder: 'Enter password',
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
                  ],
                ),
              ],
            ),
          ],
          // alignment: AlignmentDirectional.center,
        ).objectCenter(),
      ),
    );
  }
}
