import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  @override
  SignUpViewState createState() => new SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  String _name, _email, _password, _confirmPassword, errorMessage;

  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();
    final TextEditingController passCont = TextEditingController();

    // final nameField = TextFormFieldsGenerator.generateFormField(
    //   _name,
    //   AuthenticationValidation.validateName,
    //   'Name',
    //   iconData: Icons.person,
    // );

    final emailField = TextFormField(
      autofocus: false,
      validator: (email) => AuthenticationValidation.validateEmail(email),
      onSaved: (value) => _email = value,
      decoration: const InputDecoration(
        icon: Icon(Icons.email),
        labelText: 'Email',
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passCont,
      obscureText: true,
      validator: (password) =>
          AuthenticationValidation.validatePassword(password),
      onSaved: (value) => _password = value,
      decoration: const InputDecoration(
        icon: Icon(Icons.lock),
        labelText: 'Password',
      ),
    );

    final confirmPassword = TextFormField(
      autofocus: false,
      validator: (password) =>
          AuthenticationValidation.validateConfirmationPassword(
              password, passCont.text),
      onSaved: (value) => _confirmPassword = value,
      obscureText: true,
      decoration: const InputDecoration(
        icon: Icon(Icons.lock),
        labelText: 'Confirm Password',
      ),
    );

    trySignUpUser() async {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        var value = await context
            .read<AuthenticationService>()
            .signUpUserWithEmailAndPassword(email: _email, password: _password);
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
                // nameField,
                emailField,
                passwordField,
                confirmPassword,
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
