import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarCustom {
  static useSnackbarOfContext(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
