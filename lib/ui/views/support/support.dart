import 'package:app/ui/shared/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization
import 'components/faq_list_component.dart'; // Use localization

// TODO : design improvements .. should be responsive and smaller margins between components

class SupportView extends StatefulWidget {
  final _formKey = new GlobalKey<FormState>();

  formKey() => _formKey;

  @override
  _SupportViewState createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {


  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    final _formKey = widget.formKey();
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
        padding: EdgeInsets.fromLTRB(_insetStandard, 20, 0, 0),
        child: Text(
          texts.contact,
          style: _theme.textTheme.headline6,
          key: Key('Support_ContactTitle'),
        ),
      ),
    );

    final mailInputTextSubtitle = Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(_insetStandard, 5, 0, 0),
        child: Text(
          texts.typeYourInqueryBelow,
          style: _theme.textTheme.bodyText1,
          key: Key('Support_Contactsubtitle'),
        ),
      ),
    );

    final mailInputSubject = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        key: Key('Support_ContactMailSubject'),
        controller: subjectController,
        keyboardType: TextInputType.multiline,
        validator: (data) =>
            subjectController.text == '' ? 'Please enter a subject' : null,
        decoration: InputDecoration(
          labelText: texts.subject,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );

    final mailInputBody = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        key: Key('Support_ContactMailBody'),
        controller: bodyController,
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: null,
        decoration: InputDecoration(
          labelText: texts.typeYourInqueryHere,
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
        child: Button(
          key: Key('Support_SendMailButton'),
          onPressed: () => _launchRequestedMailURL(
              'test@mail.com', subjectController.text, bodyController.text),
          label: texts.send,
        ),
      ),
    );

    final faqTextTitle = Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: _insetsAll,
        child: Text(
          texts.fAQ,
          style: _theme.textTheme.headline6,
          key: Key('Support_faqTitle'),
        ),
      ),
    );

    final divider = Padding(
        padding: _insetsAll,
        child: Divider(
          thickness: 1.5,
          color: Colors.black,
        ));

    // TODO: use global theme
    final faqShowMoreButton = Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Button(
          onPressed: () => {},
          label: texts.showMore,
        ),
      ),
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
          texts.productSupport,
          style: _theme.textTheme.headline6,
          key: Key('Support_ProductSupportTitle'),
        ),
      ),
    );

    final supportViewButton = Padding(
      padding: EdgeInsets.all(8.0),
      child: Button(
        onPressed: _launchUrlForOnlineSupport,
        label: texts.goToOnlineSupportPage,
        key: Key('Support_ProductSupportButton'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(texts.support),
        backgroundColor: Colors.black,
      ),
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
              SizedBox(height: 50),
              faqTextTitle,
              // FAQExpansionPanelComponent(_faqData),
              Container(child: FAQExpansionPanelComponent(), height: 300,),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 0.3 *
                        MediaQuery.of(context)
                            .size
                            .width), // TODO: use global theme
                child: faqShowMoreButton,
              ),
              divider,
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
