import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class Editer extends StatefulWidget {
  const Editer(
      {Key? key, required this.initText, required this.title, this.isDone})
      : super(key: key);
  final String initText;
  final String title;
  final bool? isDone;

  @override
  State<Editer> createState() => _EditerState();
}

class _EditerState extends State<Editer> {
  late HtmlEditorController controller;
  @override
  void initState() {
    super.initState();
    controller = HtmlEditorController(
      processNewLineAsBr: true,
      processInputHtml: true,
      processOutputHtml: true,
    );
  }

  String get userid => '${FirebaseAuth.instance.currentUser?.uid}';

  updateTodos({
    required String todoTitle,
    required String todoDes,
    required bool taskdone,
  }) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(userid)
        .collection('Tasks')
        .doc(userid + todoTitle);

    Map<String, String> todos = {
      "todoTitle": todoTitle,
      "todoDes": todoDes,
      "taskdone": taskdone.toString()
    };

    await documentReference.set(todos).whenComplete(() {
      print(
        "$todoTitle created",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await controller.getText().then(
                (_) {
                  if (_ != null) {
                    updateTodos(
                      todoTitle: widget.title,
                      todoDes: _.toString(),
                      taskdone: widget.isDone ?? false,
                    );
                    Navigator.pop(context);
                  } else {
                    log(_.toString());
                  }
                },
              );
            },
          ),
        ],
      ),
      body: HtmlEditor(
        options: HtmlEditorOptions(
          height: height - keyboardHeight,
        ),
        controller: controller,
        initialText: widget.initText,
      ),
    );
  }
}
