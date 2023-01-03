import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({required this.signInWithGoogle, super.key});

  final Function signInWithGoogle;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  Widget buildSignInButton(
    String text,
    Function authHandler,
  ) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () => authHandler(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          textStyle: const TextStyle(
            fontSize: 20,
          ),
        ),
        child: Text(
          text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Habitualize",
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 20),
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildSignInButton(
                      "Sign in With Google",
                      widget.signInWithGoogle,
                    ),
                    buildSignInButton("Sign in With Apple", () {}),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
