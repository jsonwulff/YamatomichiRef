import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CreateAppHelper {
  static MaterialApp generateYamatomichiTestApp(Widget widget) {
    return MaterialApp(
      title: 'Yamatomichi',
      home: Scaffold(
        body: widget,
      ),
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('da', 'DK'), // Danish
        const Locale('ja', '') // Japanese, for all regions
      ],
    );
  }
}
