import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:app/ui/view/auth/reset_password.dart';
import 'package:app/ui/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization
import 'await_verified_email_dialog.dart';

class SignInView extends StatefulWidget {
  SignInView({Key key}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String email, password;
  AuthenticationService authenticationService;

  @override
  Widget build(BuildContext context) {
    UserProfileNotifier userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    authenticationService = Provider.of<AuthenticationService>(context);
    final formKey = new GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    var texts = AppLocalizations.of(context);

    final emailField = TextInputFormFieldComponent(
      emailController,
      AuthenticationValidation.validateEmail,
      'Email',
      iconData: Icons.email,
      key: Key('SignInEmail'),
    );

    final passwordField = TextInputFormFieldComponent(
      passwordController,
      AuthenticationValidation.validatePassword,
      'Password',
      iconData: Icons.lock,
      isTextObscured: true,
      key: Key('SignInPassword'),
    );

    final signUpHyperlink = InkWell(
      child: Text(
        "Don't have a user? Click here to sign up",
        style: TextStyle(color: Colors.blue),
      ),
      onTap: () => Navigator.pushNamed(context, signUpRoute),
    );

    final forgotPasswordLink = TextButton(
      onPressed: () {
        resetPasswordAlertDialog(context);
      },
      child: Text(texts.forgotPasswordButton),
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
                userProfileNotifier: userProfileNotifier);
        if (value == 'Success') {
          if (_firebaseAuth.currentUser.emailVerified)
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeView()));
          else
            generateNonVerifiedEmailAlert(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value),
          ));
        }
      }
    }

    trySignInWithGoogle() async {
      String value =
          await context.read<AuthenticationService>().signInWithGoogle();
      if (value == 'Success') {
        Navigator.pushReplacementNamed(context, homeRoute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Sign in'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
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
                  key: Key('SignInButton'),
                ),
                SignInButton(
                  Buttons.Google,
                  text: "Sign in with Google",
                  onPressed: () {
                    trySignInWithGoogle();
                  },
                ),
                signUpHyperlink,
                forgotPasswordLink
              ],
            ),
          ),
        ),
      ),
    );
  }
}
