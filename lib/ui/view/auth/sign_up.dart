import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/ui/components/global/button.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class SignUpView extends StatefulWidget {
  @override
  SignUpViewState createState() => new SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    final formKey = new GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmationPasswordController =
        TextEditingController();

    final nameField = TextInputFormFieldComponent(
      nameController,
      AuthenticationValidation.validateName,
      texts.name,
      iconData: Icons.person,
    );

    final emailField = TextInputFormFieldComponent(
      emailController,
      AuthenticationValidation.validateEmail,
      texts.email,
      iconData: Icons.email,
    );

    final passwordField = TextInputFormFieldComponent(
      passwordController,
      AuthenticationValidation.validatePassword,
      texts.password,
      iconData: Icons.lock,
      isTextObscured: true,
    );

    final confirmPasswordField = TextInputFormFieldComponent(
      confirmationPasswordController,
      AuthenticationValidation.validateConfirmationPassword,
      texts.confirmPassword,
      iconData: Icons.lock,
      isTextObscured: true,
      optionalController: passwordController,
    );

    trySignUpUser() async {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        var value = await context
            .read<AuthenticationService>()
            .signUpUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        if (value == 'Success') {
          Navigator.pushNamed(context, homeRoute);
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
          child: Image(image: AssetImage('lib/ui/assets/logo.png')),
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
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAppLogoImage(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: nameField,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Button(
                      label: texts.signUp,
                      onPressed: trySignUpUser,
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
