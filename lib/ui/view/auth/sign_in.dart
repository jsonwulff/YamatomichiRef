import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:app/ui/view/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class SignInView extends StatefulWidget {
  SignInView({Key key}) : super(key: key);

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
    final resetPassworkFormKey = new GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController passwordResetController =
        TextEditingController();

    var texts = AppLocalizations.of(context);

    final emailField = TextInputFormFieldComponent(
        emailController, AuthenticationValidation.validateEmail, 'Email',
        iconData: Icons.email, key: Key('SignInEmail'));

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

    final forgorPasswordLink = TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(''), // TODO
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: resetPassworkFormKey,
                    child: TextInputFormFieldComponent(
                      passwordResetController,
                      AuthenticationValidation.validateEmail,
                      'Email',
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      print(passwordResetController.text);
                      resetPassworkFormKey.currentState.save();
                      await context
                          .read<AuthenticationService>().sendResetPasswordLink(context, passwordResetController.text);
                    },
                    child: Text('Send mail'), // TODO
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(texts.cancel), // TODO
                  ),
                ],
              );
            });
      },
      child: Text('Forgot your password? click here'),
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
                forgorPasswordLink
              ],
            ),
          ),
        ),
      ),
    );
  }
}
