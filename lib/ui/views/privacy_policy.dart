import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class PrivacyPolicyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    final themeDataText = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBarCustom.basicAppBarWithContext(
          texts.privacyPolicyTitle, context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                texts.privacyPolicyHeading1,
                style: themeDataText.headline2,
              ),
              SizedBox(height: 25),
              Text(
                texts.privacyPolicyBody1,
                style: themeDataText.bodyText1,
              ),
              SizedBox(height: 50),
              Text(
                texts.privacyPolicyHeading2,
                style: themeDataText.headline2,
              ),
              SizedBox(height: 25),
              Text(
                texts.privacyPolicyBody2,
                style: themeDataText.bodyText1,
              ),
              SizedBox(height: 50),
              Text(
                texts.privacyPolicyHeading3,
                style: themeDataText.headline2,
              ),
              SizedBox(height: 25),
              Text(
                texts.privacyPolicyBody3,
                style: themeDataText.bodyText1,
              ),
              SizedBox(height: 50),
              Text(
                texts.privacyPolicyHeading4,
                style: themeDataText.headline2,
              ),
              SizedBox(height: 25),
              Text(
                texts.privacyPolicyBody4,
                style: themeDataText.bodyText1,
              ),
              SizedBox(height: 50),
              Text(
                texts.privacyPolicyHeading5,
                style: themeDataText.headline2,
              ),
              SizedBox(height: 25),
              Text(
                texts.privacyPolicyBody5,
                style: themeDataText.bodyText1,
              ),
              SizedBox(height: 50),
              Text(
                texts.privacyPolicyHeading6,
                style: themeDataText.headline2,
              ),
              SizedBox(height: 25),
              Text(
                texts.privacyPolicyBody6,
                style: themeDataText.bodyText1,
              ),
              SizedBox(height: 50),
              Text(
                texts.privacyPolicyHeading7,
                style: themeDataText.headline2,
              ),
              SizedBox(height: 25),
              Text(
                texts.privacyPolicyBody7,
                style: themeDataText.bodyText1,
              ),
              SizedBox(height: 50),
              Text(
                texts.privacyPolicyHeading8,
                style: themeDataText.headline2,
              ),
              SizedBox(height: 25),
              Text(
                texts.privacyPolicyBody8,
                style: themeDataText.bodyText1,
              ),
              SizedBox(height: 50),
              Text(
                texts.privacyPolicyHeading9,
                style: themeDataText.headline2,
              ),
              SizedBox(height: 25),
              Text(
                texts.privacyPolicyBody9,
                style: themeDataText.bodyText1,
              ),
              SizedBox(height: 50),
              Text(
                texts.privacyPolicyHeading10,
                style: themeDataText.headline2,
              ),
              SizedBox(height: 25),
              Text(
                texts.privacyPolicyBody10,
                style: themeDataText.bodyText1,
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
