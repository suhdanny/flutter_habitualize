import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_text_form_field.dart';
import '../services/create_new_user_with_email_and_password.dart';
import '../services/sign_in_with_google.dart';
import '../services/sign_in_with_apple.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _confirmPasswordErrorMsg;
  String? _errorMessage;

  void _setErrorMessage(message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 80,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(35),
                    topLeft: Radius.circular(35),
                  ),
                  color: Color.fromRGBO(223, 223, 223, 1),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      "Create an Account.",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushReplacementNamed(
                                  context, '/sign-in'),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    AuthTextFormField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter Your E-mail',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      hidden: false,
                    ),
                    const SizedBox(height: 20),
                    AuthTextFormField(
                      controller: _userNameController,
                      labelText: 'Username',
                      hintText: 'Enter Your Username',
                      icon: Icons.person,
                      keyboardType: TextInputType.name,
                      hidden: false,
                    ),
                    const SizedBox(height: 20),
                    AuthTextFormField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Password',
                      icon: Icons.key,
                      keyboardType: TextInputType.text,
                      hidden: true,
                    ),
                    const SizedBox(height: 20),
                    AuthTextFormField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Re-Enter Your Password',
                      icon: Icons.key,
                      keyboardType: TextInputType.text,
                      hidden: true,
                      errMsg: _confirmPasswordErrorMsg,
                    ),
                    const SizedBox(height: 20),
                    if (_errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          bool isValid = _formKey.currentState!.validate();
                          if (!isValid) return;

                          if (_passwordController.text.trim() !=
                              _confirmPasswordController.text.trim()) {
                            setState(() {
                              _confirmPasswordErrorMsg =
                                  'Passwords do not match.';
                            });
                            return;
                          } else {
                            setState(() {
                              _confirmPasswordErrorMsg = null;
                            });
                          }

                          createNewUserWithEmailAndPassword(
                            _emailController.text.trim(),
                            _userNameController.text.trim(),
                            _passwordController.text.trim(),
                            _setErrorMessage,
                          ).then((success) {
                            if (success) Navigator.pushNamed(context, '/');
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 50,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text(
                        "OR",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          signInWithGoogle().then((success) =>
                              {if (success) Navigator.pushNamed(context, '/')});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 50,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black,
                              backgroundImage: NetworkImage(
                                'https://companieslogo.com/img/orig/GOOG-0ed88f7c.png?t=1633218227',
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Continue with Google",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          signInWithApple().then((success) =>
                              {if (success) Navigator.pushNamed(context, '/')});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 50,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black,
                              backgroundImage: NetworkImage(
                                'https://www.iconsdb.com/icons/preview/white/apple-xxl.png',
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Continue with Apple",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
