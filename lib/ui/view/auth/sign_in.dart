import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();

    final emailField = TextFormFieldsGenerator.generateFormField(
      _email,
      AuthenticationValidation.validateEmail,
      'Email',
      iconData: Icons.email,
    );

    final passwordField = TextFormFieldsGenerator.generateFormField(
      _password,
      AuthenticationValidation.validateEmail,
      'Password',
      iconData: Icons.lock,
      isTextObscured: true,
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                emailField,
                passwordField,
                ElevatedButton(
                  onPressed: () => {},
                  child: Text("Sign In"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
