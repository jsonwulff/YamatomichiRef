import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';

class LoadingScreenWithNavigation extends StatelessWidget {
  final String appBarTitle;

  const LoadingScreenWithNavigation(this.appBarTitle, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom.basicAppBar(appBarTitle, context),
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
