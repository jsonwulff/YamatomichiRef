import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();

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
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    onSaved: (String value) {
                      // Same save method
                    },
                    validator: (String value) {
                      return value.isEmpty ? 'Please fill out name' : null;
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
