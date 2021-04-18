import 'package:app/middleware/firebase/support_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

faqListExpansionPanel(BuildContext context, {bool isFaqCountShowMore = false}) {
  var faqItems = Provider.of<SupportService>(context);
    var future;

     var currentLocalization = Localizations.localeOf(context);

    switch (currentLocalization.languageCode) {
      case 'en':
        future = faqItems.getEnglishFaqList();
        break;
      case 'ja':
        future = faqItems.getJapaneseFaqList();
        break;
    }
    
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: isFaqCountShowMore ? snapshot.data.length : 3,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data[index];

                return ExpansionTile(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  collapsedBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Text(data['title'],
                      style: Theme.of(context).textTheme.headline3),
                  children: [
                    Container(
                        margin: EdgeInsets.all(16.0),
                        child: ListTile(
                          title: Text(
                            data['body'],
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ))
                  ],
                );
              },
            );
          } else {
            // TODO
            return Text(AppLocalizations.of(context).somethingWentWrong1);
          }
        }
      },
    );
}