import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_text_form_field.dart';
import '../services/sign_in_with_google.dart';
import '../services/sign_in_with_email_and_password.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  void setErrorMessage(message) {
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
            const SizedBox(height: 50),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 150,
              child: const Text(
                "Haveit.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0),
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
                      "Welcome Back.",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushReplacementNamed(
                                  context, '/sign-up'),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
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
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'hintText',
                      icon: Icons.key,
                      keyboardType: TextInputType.text,
                      hidden: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
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

                          signInWithEmailAndPassword(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            setErrorMessage,
                          );
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
                          "Sign In",
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
                        onPressed: () => signInWithGoogle(),
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
                        onPressed: () {},
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
