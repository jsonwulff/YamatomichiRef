import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';
// import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = new GlobalKey<FormState>();
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    var subjectController = TextEditingController();
    var bodyController = TextEditingController();

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

    final mailSendButton = ElevatedButton(
        onPressed: () => _launchRequestedMailURL('test@mail.com', subjectController.text, bodyController.text),
        child: Text('Send'));

    final faqs = Text("TBA");

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

    final supportPageText = Text(
        'If you need help with any of our products, please have a look at our website for details.');

    final supportPageButton = Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _launchUrlForOnlineSupport,
        child: Text('Go to online support page'),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    mailInputSubject,
                    mailInputBody,
                    mailSendButton,
                  ],
                ),
              ),
              faqs,
              supportPageText,
              supportPageButton,
            ],
          ),
        ),
      ),
    );
  }
}
