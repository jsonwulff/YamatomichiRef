import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class CustomAppBar extends StatelessWidget {
  final String text;

  CustomAppBar(this.text);

  @override
  Widget build(BuildContext context) {
    return AppBar(
          brightness: Brightness.dark,
          title: Text(text),
        );
  }
}