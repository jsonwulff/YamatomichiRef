import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordView extends StatefulWidget {
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
    String value =
        await context.read<AuthenticationService>().changePassword(passwordController.text);
    if (value == 'Password changed') {
      Navigator.pop(context);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBarCustom.basicAppBarWithContext(texts.changePassword, context),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: texts.newPassword),
                    controller: passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return AuthenticationValidation.validatePassword(value);
                    },
                    obscureText: true,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: texts.confirmNewPassword),
                    validator: (value) {
                      return AuthenticationValidation.validateConfirmationPassword(
                          value, passwordController.text);
                    },
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _changePassword();
                    },
                    child: Text(texts.changePassword),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
