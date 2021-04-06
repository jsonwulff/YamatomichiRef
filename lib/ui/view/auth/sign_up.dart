import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/middleware/firebase/email_verification.dart';
import 'package:app/ui/components/global/button.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization
import 'await_verified_email_dialog.dart';

class SignUpView extends StatefulWidget {
  final _formKey = new GlobalKey<FormState>();

  formKey() => _formKey;

  @override
  SignUpViewState createState() => new SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  bool agree = false;
  // final formKey = new GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationPasswordController = TextEditingController();
  final EmailVerification _emailVerification = EmailVerification(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    var _formKey = widget._formKey; // SignUpView().formKey();

    final firstNameField = TextInputFormFieldComponent(
      firstNameController,
      AuthenticationValidation.validateFirstName,
      'First name',
      key: Key('SignUp_FirstNameFormField'),
    );

    final lastNameField = TextInputFormFieldComponent(
        lastNameController, AuthenticationValidation.validateLastName, 'Last name',
        key: Key('SignUp_LastNameFormField'));

    final emailField = TextInputFormFieldComponent(
      emailController,
      AuthenticationValidation.validateEmail,
      texts.email,
      iconData: Icons.email,
      key: Key('SignUp_EmailFormField'),
    );

    final passwordField = TextInputFormFieldComponent(
      passwordController,
      AuthenticationValidation.validatePassword,
      texts.password,
      iconData: Icons.lock,
      isTextObscured: true,
      key: Key('SignUp_PasswordFormField'),
    );

    final confirmPasswordField = TextInputFormFieldComponent(
      confirmationPasswordController,
      AuthenticationValidation.validateConfirmationPassword,
      texts.confirmPassword,
      iconData: Icons.lock,
      isTextObscured: true,
      optionalController: passwordController,
      key: Key('SignUp_ConfirmPasswordFormField'),
    );

    trySignUpUser() async {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        if (agree != true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            key: Key('Terms_not_accepted_warning'),
            content: Text('Please accept the terms and conditions to sign up'),
          ));
          return;
        }
        var value = await context.read<AuthenticationService>().signUpUserWithEmailAndPassword(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        if (value == 'Success') {
          var user = await _emailVerification.sendVerificationEmail();
          if (user.emailVerified)
            Navigator.pushNamedAndRemoveUntil(context, homeRoute, (Route<dynamic> route) => false);
          else
            generateNonVerifiedEmailAlert(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value), // TODO use localization
          ));
        }
      }
    }

    _buildAppLogoImage() {
      return Container(
        height: 150.0,
        width: 190.0,
        padding: EdgeInsets.only(top: 0, bottom: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
        ),
        child: Center(
          child: Image(image: AssetImage('lib/ui/assets/logo_2.png')),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(texts.signUp),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAppLogoImage(),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: emailField,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: passwordField,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: confirmPasswordField,
                  ),
                  Row(
                    children: [
                      Material(
                        child: Checkbox(
                          value: agree,
                          key: Key('Terms_checkbox'),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Button(
                      label: texts.signUp,
                      onPressed: trySignUpUser,
                      key: Key('SignUp_SignUpButton'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
