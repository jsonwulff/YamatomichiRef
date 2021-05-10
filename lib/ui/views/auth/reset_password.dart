import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/middleware/firebase/dynamic_links_service.dart';
import 'package:app/ui/shared/form_fields/text_form_field_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

Future<Widget> resetPasswordAlertDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      var texts = AppLocalizations.of(context);
      final TextEditingController passwordResetController =
          TextEditingController();
      final resetPassworkFormKey = new GlobalKey<FormState>();
      return AlertDialog(
        title: Text(
          texts.resetPassword,
          key: Key('ResetPassword_ResetPasswordText'),
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: resetPassworkFormKey,
            child: TextInputFormFieldComponent(
              passwordResetController,
              AuthenticationValidation.validateEmail,
              texts.email,
              key: Key('ResetPassword_EmailInputFormField'),
            ),
          ),
        ),
        actions: [
          TextButton(
            key: Key('ResetPassword_SendMailButton'),
            onPressed: () async {
              if (resetPassworkFormKey.currentState.validate()) {
                var enteredMail = passwordResetController.text.trim() ;

                await context
                    .read<AuthenticationService>()
                    .sendResetPasswordLink(
                        context, enteredMail, actionCodeSettings: DynamicLinkService.generateResetPasswordCode(enteredMail));
                
                Navigator.pop(context);
              }
            },
            child: Text(texts.sendMail),
          ),
          TextButton(
            key: Key('ResetPassword_CancelButton'),
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
