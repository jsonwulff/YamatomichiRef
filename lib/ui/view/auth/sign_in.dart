import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:app/ui/view/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInView extends StatefulWidget {
  SignInView({Key key}) : super (key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String email, password;

  @override
  Widget build(BuildContext context) {
    UserProfileNotifier userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
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

    final signUpHyperlink = InkWell(
      child: Text(
        "Don't have a user? Click here to sign up",
        style: TextStyle(color: Colors.blue),
      ),
      onTap: () => Navigator.pushNamed(context, signUpRoute),
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
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => HomeView()));
          // Navigator.pushNamed(context, "/");
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
                signUpHyperlink,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
