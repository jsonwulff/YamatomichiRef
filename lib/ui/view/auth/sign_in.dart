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
    var texts = AppLocalizations.of(context);

    UserProfileNotifier userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    final formKey = new GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    //final String dogUrl = 'https://www.svgrepo.com/show/2046/dog.svg';
    //final double widthOfScreen = MediaQuery.of(context).size.width;
    //final double heightOfScreen = MediaQuery.of(context).size.height;
    final emailField = TextInputFormFieldComponent(
        emailController, AuthenticationValidation.validateEmail, texts.email,
        iconData: Icons.email, key: Key('SignInEmail'));

    final passwordField = TextInputFormFieldComponent(
      passwordController,
      AuthenticationValidation.validatePassword,
      texts.password,
      iconData: Icons.lock,
      isTextObscured: true,
      key: Key('SignInPassword'),
    );

    final signUpHyperlink = InkWell(
      child: Text(
        texts.clickHereToSignUp,
        style: TextStyle(color: Colors.blue),
      ),
      onTap: () => Navigator.pushNamed(context, signUpRoute),
    );
    final forgotPasswordHyperlink = InkWell(
      child: Text(
        texts.forgotPassword,
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

    _buildAppLogoImage() {
      return Container(
        height: 250.0,
        width: 290.0,
        padding: EdgeInsets.only(top: 0, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
        ),
        child: Center(
          child: Image(image: AssetImage('lib/ui/assets/logo.png')),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(texts.signIn),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 10, bottom: 150),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAppLogoImage(),
                  emailField,
                  passwordField,
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: forgotPasswordHyperlink,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Button(
                      label: texts.signIn,
                      key: Key('SignInButton'),
                      onPressed: () {
                        formKey.currentState.save();
                        trySignInUser();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: signUpHyperlink,
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
