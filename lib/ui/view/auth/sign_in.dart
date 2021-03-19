import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:app/ui/assets/app_icons.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:app/ui/components/global/button.dart';
import 'package:app/ui/view/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

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
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    //final String dogUrl = 'https://www.svgrepo.com/show/2046/dog.svg';
    final double widthOfScreen = MediaQuery.of(context).size.width;
    final double heightOfScreen = MediaQuery.of(context).size.height;
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
    final forgotPasswordHyperlink = InkWell(
      child: Text(
        "Forgot Password",
        style: TextStyle(color: Colors.blue),
      ),
      //onTap: () => Navigator.pushNamed(context, signUpRoute),
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1.0),
        brightness: Brightness.dark,
        title: Text('Sign in'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              //child: Column(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                        left: widthOfScreen / 3,
                        top: 0.0,
                        right: widthOfScreen / 3,
                        bottom: heightOfScreen / 20,
                      ),
                      child: Image(image: AssetImage('assets/LOGO.png'))),
                  emailField,
                  passwordField,
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.0),
                      child: forgotPasswordHyperlink),
                  Button(
                    label: "Sign In",
                    key: Key('SignInButton'),
                    onPressed: () {
                      formKey.currentState.save();
                      trySignInUser();
                    },
                  ),
                  signUpHyperlink,
                  //Padding(
                  //    padding: EdgeInsets.symmetric(
                  //        vertical: MediaQuery.of(context).size.height / 10)),
                ],
              ),
              //),
            ),
          ),
        ),
      ),
    );
  }
}
