import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signInWithEmailAndPassword(
  String email,
  String password,
  Function setErrorMessage,
) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    setErrorMessage(e.message);
    return false;
  }
}
