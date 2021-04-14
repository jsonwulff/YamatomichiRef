import 'dart:async';

import 'package:app/middleware/firebase/support_service.dart';
import 'package:app/middleware/models/faq.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'faq_item.dart';

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

    var future = faqItems.getFaqItems();

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            DocumentSnapshot data = snapshot.data[index];
            // print(data['body']);
            // return Text(data['title']);
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
      },
    );
  }
}
