import 'package:app/path/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:velocity_x/velocity_x.dart';

class Todo extends StatefulWidget {
  final String userid;
  const Todo({this.userid = 'No'});

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  String todoTitle = "";
  String todoDes = "";
  bool taskdone = false;
  String get userid => '${FirebaseAuth.instance.currentUser?.uid}';
  createTodos({required String description}) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(userid)
        .collection('Tasks')
        .doc(userid + todoTitle);

    Map<String, String> todos = {
      "todoTitle": todoTitle,
      "todoDes": description,
      "taskdone": taskdone.toString()
    };

    documentReference.set(todos).whenComplete(() {
      print(
        "$todoTitle created",
      );
    });
  }

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

  deleteTodos(item) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(userid)
        .collection('Tasks')
        .doc(userid + item);

    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    logout() {
      FirebaseAuth.instance.signOut();
      context.pushNamed(MyPath.login);
    }

    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: logout,
          style: ButtonStyle(),
          child: Icon(Icons.logout_outlined),
        ).box.roundedFull.makeCentered(),
        elevation: 0.0,
        title: Center(child: Text("KrInfinity Tasks")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                HtmlEditorController controller = HtmlEditorController(
                  processNewLineAsBr: true,
                  processInputHtml: true,
                  processOutputHtml: true,
                );
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Container(
                    width: width * 0.5,
                    height: height * 0.1,
                    child: TextField(
                      style: TextStyle(),
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'Enter title here',
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.5)),
                      ),
                      onChanged: (String value) {
                        todoTitle = value;
                      },
                    ),
                  ),
                  content: HtmlEditor(
                    options: HtmlEditorOptions(
                      height: height - keyboardHeight,
                    ),
                    controller: controller,
                    hint: 'Enter description here',
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () async {
                          final des = await controller.getText();
                          createTodos(description: des.toString());

                          Navigator.of(context).pop();
                        },
                        child: Text("Add"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.userid)
              .collection('Tasks')
              .snapshots(),
          // FirebaseFirestore.instance.collection(widget.userid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshots) {
            if (snapshots.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshots.data!.docs[index];
                    return documentSnapshot["taskdone"] == "false"
                        ? Dismissible(
                            onDismissed: (direction) {
                              deleteTodos(documentSnapshot["todoTitle"]);
                            },
                            key: Key(documentSnapshot["todoTitle"]),
                            child: Card(
                              elevation: 4,
                              margin: EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: ListTile(
                                onTap: () {
                                  if (userid == 'No' || userid == 'null') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Please login to edit your tasks'),
                                      ),
                                    );
                                    return;
                                  } else {
                                    context.pushNamed(
                                      MyPath.editer,
                                      params: {
                                        'id': userid,
                                        'title': documentSnapshot["todoTitle"]
                                            .toString(),
                                      },
                                      queryParams: {
                                        'done': documentSnapshot["taskdone"],
                                      },
                                      extra: documentSnapshot["todoDes"]
                                          .toString(),
                                    );
                                  }
                                },
                                title: Text(documentSnapshot["todoTitle"]),
                                subtitle: HtmlWidget(
                                  documentSnapshot["todoDes"],
                                ),
                                trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      deleteTodos(
                                          documentSnapshot["todoTitle"]);
                                    }),
                              ),
                            ))
                        : Text('');
                  });
            } else {
              return Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
