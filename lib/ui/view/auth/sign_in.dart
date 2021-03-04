import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String email, password;

  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final emailField = TextInputFormFieldComponent(
      emailController,
      AuthenticationValidation.validateEmail,
      'Email',
      iconData: Icons.email,
    );

    final passwordField = TextInputFormFieldComponent(
      passwordController,
      AuthenticationValidation.validatePassword,
      'Password',
      iconData: Icons.lock,
      isTextObscured: true,
    );

    trySignInUser() async {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        var value = await context
            .read<AuthenticationService>()
            .signInUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
        if (value == 'Success') {
          Navigator.pushNamed(context, "/");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value),
          ));
        } 
      }
    }

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
                  onPressed: () {
                    formKey.currentState.save();
                    trySignInUser();
                  },
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
