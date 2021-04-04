import 'package:flutter/material.dart';

class AppBarCustom {
  static basicAppBar(String text) {
    return AppBar(
      title: Text(text),
      brightness: Brightness.dark,
      backgroundColor: Colors.black,
    );
  }

  static basicAppBarWithContext(String text, BuildContext context) {
    return AppBar(
      title: Text(text),
      brightness: Brightness.dark,
      backgroundColor: Colors.black,
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
