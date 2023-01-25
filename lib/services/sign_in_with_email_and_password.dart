import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential?> signInWithEmailAndPassword(
  String email,
  String password,
  Function setErrorMessage,
) async {
  try {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    setErrorMessage(e.message);
    return null;
  }
}
