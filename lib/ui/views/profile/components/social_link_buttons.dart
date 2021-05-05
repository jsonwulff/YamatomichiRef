import 'package:app/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SocialLinkButtons extends StatefulWidget {
  @override
  _SocialLinkButtonsState createState() => _SocialLinkButtonsState();
}

class _SocialLinkButtonsState extends State<SocialLinkButtons> {
  AppLocalizations texts;

  Widget _buildGoogleLinkButton() {
    return ElevatedButton(
      onPressed: () async {
        String value = await context.read<AuthenticationService>().linkEmailWithGoogle();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value),
        ));
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Colors.grey[300],
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('lib/assets/images/google_logo.png'),
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                texts.linkWithGoogle,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Color(0xff545871),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10),
      child: InkWell(
        child: Text(
          texts.changePassword,
          style: TextStyle(color: Colors.blue, fontSize: 14),
        ),
        onTap: () => Navigator.pushNamed(context, changePasswordRoute),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    texts = AppLocalizations.of(context);

    return FutureBuilder(
      future: context.read<AuthenticationService>().loginMethods(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          return Column(children: [
            if (snapshot.data.contains('google.com')) _buildGoogleLinkButton(),
            if (snapshot.data.contains('password')) _buildChangePasswordButton()
          ]);
        } else if (snapshot.hasError) {
          return Text('Has error');
        } else {
          return Text('loading');
        }
      },
    );
  }
}
