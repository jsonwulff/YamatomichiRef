import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;

  FilterAppBar({
    Key key,
    this.appBarTitle,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return AppBar(
      leadingWidth: 100,
      leading: Container(
        child: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            texts.cancel,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
      title: Text(appBarTitle,
          style: TextStyle(color: Colors.black, fontSize: 17)),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(texts.apply),
          ),
        ),
      ],
    );
  }
}
