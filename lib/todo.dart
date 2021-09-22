import 'package:app/path/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  final String userid;
  Todo({required this.userid});

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  String todoTitle = "";
  String todoDes = "";
  bool taskdone = false;

  createTodos() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userid)
        .collection('Tasks')
        .doc(todoTitle);

    // DocumentReference documentReference =
    //     FirebaseFirestore.instance.collection(widget.userid).doc(todoTitle);

    Map<String, String> todos = {
      "todoTitle": todoTitle,
      "todoDes": todoDes,
      "taskdone": taskdone.toString()
    };

    documentReference.set(todos).whenComplete(() {
      print(
        "$todoTitle created",
      );
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userid)
        .collection('Tasks')
        .doc(item);

    // DocumentReference documentReference =
    //     FirebaseFirestore.instance.collection(widget.userid).doc(item);

    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    logout() {
      FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, MyPath.loginPath);
    }

    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: logout,
          child: Icon(Icons.ac_unit),
        ),
        title: Text("mytodos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
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
                  content: TextField(
                    style: TextStyle(backgroundColor: Colors.white),
                    autocorrect: true,
                    decoration:
                        InputDecoration(hintText: 'Enter description here'),
                    onChanged: (String value) {
                      todoDes = value;
                    },
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          createTodos();

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
                                title: Text(documentSnapshot["todoTitle"]),
                                subtitle: Text(
                                  documentSnapshot["todoDes"],
                                  overflow: TextOverflow.ellipsis,
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
