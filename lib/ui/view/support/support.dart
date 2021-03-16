import 'package:app/ui/components/support/FAQ_item.dart';
import 'package:app/ui/components/support/faq_list_component.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportView extends StatefulWidget {
  @override
  _SupportViewState createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  List<FAQItem> _faqData = List.generate(
    3,
    (index) {
      return FAQItem('Title $index', 'This is the body of item $index');
    },
  );

  @override
  Widget build(BuildContext context) {
    final _formKey = new GlobalKey<FormState>();
    final _theme = Theme.of(context);
    const _insetStandard = 8.0;
    const _insetsAll = EdgeInsets.all(_insetStandard);

    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    var subjectController = TextEditingController();
    var bodyController = TextEditingController();

    final mailInputTextTitle = Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(_insetStandard, 0, 0, 0),
        child: Text(
          'Contact',
          style: _theme.textTheme.headline6,
          key: Key('ContactTitle'),
        ),
      ),
    );

    final mailInputTextSubtitle = Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(_insetStandard, 0, 0, 0),
        child: Text(
          'Type your inquery below',
          style: _theme.textTheme.bodyText1,
        ),
      ),
    );

    final mailInputSubject = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: subjectController,
        keyboardType: TextInputType.multiline,
        validator: (data) =>
            subjectController.text == '' ? 'Please enter a subject' : null,
        decoration: InputDecoration(
          labelText: 'Subject/Title',
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );

    final mailInputBody = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: bodyController,
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: null,
        decoration: InputDecoration(
          labelText: 'Type your inquery here',
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );

    _launchRequestedMailURL(
        String toMailId, String subject, String body) async {
      _formKey.currentState.save();
      var url = 'mailto:$toMailId?subject=$subject&body=$body';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    final mailSendButton = Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, _insetStandard, 0),
        child: ElevatedButton(
          onPressed: () => _launchRequestedMailURL(
              'test@mail.com', subjectController.text, bodyController.text),
          child: Text('Send'),
        ),
      ),
    );

    final faqTextTitle = Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: _insetsAll,
        child: Text(
          'FAQ',
          style: _theme.textTheme.headline6,
        ),
      ),
    );

    // TODO: use global theme
    final faqShowMoreButton = ElevatedButton(
      onPressed: () => {},
      child: Text('Show More'),
    );

    _launchUrlForOnlineSupport() async {
      const url = 'https://www.yamatomichi.com/en/support/online/';
      await canLaunch(url)
          ? await launch(url)
          : scaffoldMessengerKey.currentState.showSnackBar(
              SnackBar(
                content: Text('Couldn\'t access the link'),
              ),
            );
    }

    final supportViewText = Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(_insetStandard, 0, _insetStandard, 0),
        child: Text(
          'Product Support',
          style: _theme.textTheme.headline6,
        ),
      ),
    );

    final supportViewButton = Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _launchUrlForOnlineSupport,
        child: Text('Go to online support page'),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: _insetsAll,
          child: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    mailInputTextTitle,
                    mailInputTextSubtitle,
                    mailInputSubject,
                    mailInputBody,
                    mailSendButton,
                  ],
                ),
              ),
              SizedBox(height: 100),
              faqTextTitle,
              FAQExpansionPanelComponent(_faqData),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 0.3 *
                        MediaQuery.of(context)
                            .size
                            .width), // TODO: use global theme
                child: faqShowMoreButton,
              ),
              SizedBox(height: 100),
              supportViewText,
              supportViewButton,
            ],
          ),
        ),
      ),
    );
  }
}
