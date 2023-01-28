import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/create_new_user_with_credential.dart';

Future<bool> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    await createNewUserWithCredential(userCredential);

    return true;
  } on PlatformException catch (error) {
    debugPrint(error.message);
    return false;
  } on FirebaseAuthException catch (error) {
    debugPrint(error.message);
    return false;
  }
}
