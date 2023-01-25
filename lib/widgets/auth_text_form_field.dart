import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class AuthTextFormField extends StatefulWidget {
  const AuthTextFormField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.keyboardType,
    required this.hidden,
    this.errMsg,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final bool hidden;
  final String? errMsg;

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    if (widget.hidden) {
      _obscureText = true;
    }
  }

  getValidator() {
    if (widget.labelText == 'Email') {
      return (email) =>
          email == null || email.isEmpty || !EmailValidator.validate(email)
              ? 'Please enter a valid email address.'
              : null;
    } else if (widget.labelText == 'Password') {
      return (password) => password == null || password.isEmpty
          ? 'Please enter a valid password.'
          : null;
    } else if (widget.labelText == 'Username') {
      return (username) => username == null || username.isEmpty
          ? 'Please enter a valid username.'
          : null;
    } else if (widget.labelText == 'Confirm Password') {
      return (confirmPassword) =>
          confirmPassword == null || confirmPassword.isEmpty
              ? 'Please enter a valid password'
              : null;
    }
  }

  getErrorText() {
    if (widget.labelText != 'Confirm Password') return null;
    if (widget.errMsg != null) {
      return widget.errMsg;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: getValidator(),
      obscureText: _obscureText,
      cursorColor: Colors.black,
      keyboardType: widget.keyboardType,
      onChanged: (value) {
        widget.controller.text = value;
        widget.controller.selection =
            TextSelection.fromPosition(TextPosition(offset: value.length));
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: getErrorText(),
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 15.0,
        ),
        prefixIcon: Icon(
          widget.icon,
          color: Colors.black,
          size: 18,
        ),
        suffixIcon: widget.hidden
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  Icons.visibility,
                  size: 18,
                  color: _obscureText ? Colors.grey : Colors.black,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
