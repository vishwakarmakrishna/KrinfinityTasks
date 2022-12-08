import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String userid;
  final String email;
  final String password;
  DatabaseService({
    required this.userid,
    required this.email,
    required this.password,
  });
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  Future updateUserData(email, userid, password) async {
    return await userCollection.doc(userid).set({
      'email': email,
      'userid': userid,
      'password': password,
    });
  }

  Future getUserData(userid) async {
    return await userCollection.doc(userid).get();
  }
}
