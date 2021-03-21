import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/routes/routes.dart';

class SignUpView extends StatefulWidget {
  @override
  SignUpViewState createState() => new SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  bool agree = false;
  final formKey = new GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nameField = TextInputFormFieldComponent(
      nameController,
      AuthenticationValidation.validateName,
      'Name',
      iconData: Icons.person,
    );

    final emailField = TextInputFormFieldComponent(
      emailController,
      AuthenticationValidation.validateEmail,
      "Email",
      iconData: Icons.email,
    );

    final passwordField = TextInputFormFieldComponent(
      passwordController,
      AuthenticationValidation.validatePassword,
      "Password",
      iconData: Icons.lock,
      isTextObscured: true,
    );

    final confirmPasswordField = TextInputFormFieldComponent(
      confirmationPasswordController,
      AuthenticationValidation.validateConfirmationPassword,
      "Confirm Password",
      iconData: Icons.lock,
      isTextObscured: true,
      optionalController: passwordController,
    );

    trySignUpUser() async {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();
        if (agree != true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please accept the terms and conditions to sign up'),
          ));
          return;
        }
        var value = await context
            .read<AuthenticationService>()
            .signUpUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        if (value == 'Success') {
          Navigator.pushNamed(context, homeRoute);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value),
          ));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Sign up'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                nameField,
                emailField,
                passwordField,
                confirmPasswordField,
                Row(
                  children: [
                    Material(
                      child: Checkbox(
                        value: agree,
                        onChanged: (value) {
                          setState(() {
                            agree = value;
                          });
                        },
                      ),
                    ),
                    RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'I have read and accept the ',
                          style: new TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'terms and conditions',
                          style: TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, termsRoute);
                            },
                        ),
                      ],
                    )),
                  ],
                ),
                ElevatedButton(
                  onPressed: trySignUpUser,
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
