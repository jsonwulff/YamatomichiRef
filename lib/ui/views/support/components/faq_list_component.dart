import 'dart:async';

import 'package:app/middleware/firebase/support_service.dart';
import 'package:app/middleware/models/faq.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'faq_item.dart';

class FAQExpansionPanelComponent extends StatefulWidget {
  FAQExpansionPanelComponent(this.faqData);

  final List<FAQItem> faqData;

  @override
  _FAQExpansionPanelComponentState createState() => _FAQExpansionPanelComponentState();
}

class _FAQExpansionPanelComponentState extends State<FAQExpansionPanelComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildPanel(),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          widget.faqData[index].isExpanded = !isExpanded;
        });
      },
      children: widget.faqData.map<ExpansionPanel>((FAQItem item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.header),
            );
          },
          body: ListTile(
            title: Text(item.expandedBody),
            subtitle: Text('To delete this panel, tap the trash can icon'),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

Widget faqItems(BuildContext context) {
  List<FaqItem> faqItemsList = [];
  var faqItems = Provider.of<SupportService>(context);
  // ignore: cancel_subscriptions
  var faqStreamSubscription = faqItems.faqItems().listen((event) {
    faqItemsList.add(event);
  });

  return ListView.builder(
    itemCount: faqItemsList.length,
    itemBuilder: (context, index) {
      return Column(
        children: [Text(faqItemsList[index].title)],
      );
    },
  );
}
