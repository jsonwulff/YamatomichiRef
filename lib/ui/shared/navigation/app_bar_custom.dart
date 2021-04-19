import 'package:flutter/material.dart';

class AppBarCustom {
  static basicAppBar(String text, context) {
    return AppBar(
      title: Text(
        text,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  static basicAppBarWithContext(String text, BuildContext context) {
    return AppBar(
      title: Text(
        text,
        style: Theme.of(context).textTheme.headline1,
      ),
      leading: new IconButton(
        icon: new Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
