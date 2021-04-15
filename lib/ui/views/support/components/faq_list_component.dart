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

    // TODO : we're calling the field names as they are in firestore, and not using DTO or similar - not good
    
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
              shrinkWrap: true,
              itemCount: isFaqCountShowMore ? snapshot.data.length : 3,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data[index];

                return ExpansionTile(
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
            return Text('No Data');
          }
        }
      },
    );
}