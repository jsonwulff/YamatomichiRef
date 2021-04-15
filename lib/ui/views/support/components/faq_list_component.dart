import 'package:app/middleware/firebase/support_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FAQExpansionPanelComponent extends StatefulWidget {
  FAQExpansionPanelComponent();

  @override
  _FAQExpansionPanelComponentState createState() =>
      _FAQExpansionPanelComponentState();
}

class _FAQExpansionPanelComponentState
    extends State<FAQExpansionPanelComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: faqItems(context),
    );
  }

  Widget faqItems(BuildContext context) {
    var faqItems = Provider.of<SupportService>(context);

    var future = faqItems.getEnglishFaqList();
    // var future = faqItems.getFaqItems();

    // TODO : logic for handling english or japanese language setting
    //  - im thinking 4 fields in every record in db :
    //  1) title_english
    //  2) body_english
    //  3) title_japanese
    //  4) body_japanese
    //
    //  - insert title and body accordingly
    //
    //
    // TODO : we're calling the field names as they are in firestore, and not using DTO or similar - not good
    // TODO : errorhandling for the futurebuilder
    //  - right now, it quickly throws an exception before rerendering via the futurebuilder
    //  - proposal : append a progress indicator as child when snapshot.data == null

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
              itemCount: snapshot.data.length,
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
}
