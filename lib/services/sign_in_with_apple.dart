import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/create_new_user_with_credential.dart';

Future<bool> signInWithApple() async {
  final AuthorizationResult result = await TheAppleSignIn.performRequests([
    const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  ]);

  switch (result.status) {
    case AuthorizationStatus.authorized:
      final AppleIdCredential appleIdCredential = result.credential!;
      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: String.fromCharCodes(appleIdCredential.identityToken!),
        accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await createNewUserWithCredential(userCredential);

      return true;
      break;

    case AuthorizationStatus.error:
      print("Sign in failed: ${result.error!.localizedDescription}");

      return false;
      break;

    case AuthorizationStatus.cancelled:
      print('User cancelled');

      return false;
      break;
  }
}
