import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:app/ui/shared/snackbar/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordView extends StatefulWidget {
  final String resetPasswordActionCode;

  ChangePasswordView({this.resetPasswordActionCode});

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  _changePassword() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      return;
    }
    
    String value;

    widget.resetPasswordActionCode != null
        ? value = await context.read<AuthenticationService>().changePassword(
            passwordController.text,
            actionCodeSettings: widget.resetPasswordActionCode)
        : value =
            await context.read<AuthenticationService>().changePassword(passwordController.text);
    if (value == 'Password changed') {
      SnackBarCustom.useSnackbarOfContext(context, AppLocalizations.of(context).success);
      Navigator.pop(context);
    } else {
      SnackBarCustom.useSnackbarOfContext(context, AppLocalizations.of(context).sorryErrorOccurred);
    }
  }

  _buildAppLogoImage() {
    return Container(
      height: 150.0,
      width: 190.0,
      padding: EdgeInsets.only(top: 0, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
      ),
      child: Center(
        child: Image(image: AssetImage('lib/assets/images/logo_2.png')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations texts = AppLocalizations.of(context);

    return Scaffold(
      appBar:
          AppBarCustom.basicAppBarWithContext(texts.changePassword, context),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 100),
                child: _buildAppLogoImage()),
            Center(
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: texts.newPassword),
                          controller: passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return AuthenticationValidation.validatePassword(
                                value);
                          },
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: texts.confirmNewPassword),
                          validator: (value) {
                            return AuthenticationValidation
                                .validateConfirmationPassword(
                                    value, passwordController.text);
                          },
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Button(
                          label: texts.changePassword,
                          onPressed: () {
                            _changePassword();
                          },
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
