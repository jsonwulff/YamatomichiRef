import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

resetPasswordAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      var texts = AppLocalizations.of(context);
      final TextEditingController passwordResetController =
          TextEditingController();
      final resetPassworkFormKey = new GlobalKey<FormState>();
      return AlertDialog(
        title: Text(texts.resetPassword),
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
              if (resetPassworkFormKey.currentState.validate()) {
                print(passwordResetController.text);
                await context
                    .read<AuthenticationService>()
                    .sendResetPasswordLink(
                        context, passwordResetController.text);
                Navigator.pop(context);
              }
            },
            child: Text(texts.sendMail), 
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(texts.cancel), 
          ),
        ],
      );
    },
  );
}
