import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    String value = await context
        .read<AuthenticationService>()
        .changePassword(passwordController.text);
    if (value == 'Password changed') {
      Navigator.pop(context);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Change password'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'New password'),
                    controller: passwordController,
                    validator: (value) {
                      return AuthenticationValidation.validatePassword(value);
                    },
                    obscureText: true,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Confirm new password'),
                    validator: (value) {
                      return AuthenticationValidation
                          .validateConfirmationPassword(
                              value, passwordController.text);
                    },
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _changePassword();
                    },
                    child: Text('Change password'),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
