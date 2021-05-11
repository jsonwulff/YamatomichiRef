import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarCustom {
  static useSnackbarOfContext(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
