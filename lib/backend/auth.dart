import 'package:app/backend/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> login(String email, String password) async {
  try {
    var result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    SharedPreferences emailprefs = await SharedPreferences.getInstance();
    emailprefs.setString('email', email);
    var userid = result.user!.uid;
    return userid;
  } catch (e) {
    print(e);
    return 'No';
  }
}

Future<String> signup({
  required String email,
  required String password,
  required String username,
}) async {
  try {
    var result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    var userid = result.user!.uid;
    var fireusers =
        DatabaseService(email: email, userid: userid, password: password)
            .updateUserData(email, userid, password);
    SharedPreferences emailprefs = await SharedPreferences.getInstance();
    emailprefs.setString('email', email);
    print("************************************************");
    print(fireusers);
    return userid;
  } on FirebaseAuthException catch (e) {
    if (e.code == "weak-password") {
      print('Password is weak');
    } else if (e.code == 'email-already-in-use') {
      print('Account already in use');
    }
    print(e);
    return 'No';
  } catch (e) {
    print("there is an exception");
    return 'No';
  }
}
