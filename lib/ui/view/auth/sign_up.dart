import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/middleware/firebase/email_verification.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/routes/routes.dart';

import 'await_verified_email_dialog.dart';

class SignUpView extends StatefulWidget {
  @override
  SignUpViewState createState() => new SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  bool agree = false;
  final formKey = new GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationPasswordController = TextEditingController();
  final EmailVerification _emailVerification = EmailVerification(FirebaseAuth.instance);
  
  @override
  Widget build(BuildContext context) {
    //final formKey = new GlobalKey<FormState>();
    //final TextEditingController nameController = TextEditingController();
    //final TextEditingController emailController = TextEditingController();
    //final TextEditingController passwordController = TextEditingController();
    //final TextEditingController confirmationPasswordController =
    //    TextEditingController();
    

    final firstNameField = TextInputFormFieldComponent(
      firstNameController,
      AuthenticationValidation.validateFirstName,
      'First name',
      
      iconData: Icons.person,
      key: Key('SignUp_NameFormField'),
    );

    final lastNameField = TextInputFormFieldComponent(
      lastNameController,
      AuthenticationValidation.validateLastName,
      'Last name',
    );

    final emailField = TextInputFormFieldComponent(
      emailController,
      AuthenticationValidation.validateEmail,
      "Email",
      iconData: Icons.email,
      key: Key('SignUp_EmailFormField'),
    );

    final passwordField = TextInputFormFieldComponent(
      passwordController,
      AuthenticationValidation.validatePassword,
      "Password",
      iconData: Icons.lock,
      isTextObscured: true,
      key: Key('SignUp_PasswordFormField'),
    );

    final confirmPasswordField = TextInputFormFieldComponent(
      confirmationPasswordController,
      AuthenticationValidation.validateConfirmationPassword,
      "Confirm Password",
      iconData: Icons.lock,
      isTextObscured: true,
      optionalController: passwordController,
      key: Key('SignUp_PasswordConfirmFormField'),
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
        var value = await context.read<AuthenticationService>().signUpUserWithEmailAndPassword(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text);
        if (value == 'Success') {
          var user = await _emailVerification.sendVerificationEmail();
          if (user.emailVerified)
            Navigator.pushNamedAndRemoveUntil(
                context, homeRoute, (Route<dynamic> route) => false);
          else
            generateNonVerifiedEmailAlert(context);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: firstNameField,
                    )),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: lastNameField,
                      ),
                    )
                  ],
                ),
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
                  key: Key('SignUp_SignUpButton'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
