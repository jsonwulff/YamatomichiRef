import 'package:app/ui/routes/routes.dart';
import 'package:app/ui/shared/buttons/google_auth_button.dart';
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
    return GoogleAuthButton(
      text: texts.linkWithGoogle,
      onPressed: () async {
        String value = await context.read<AuthenticationService>().linkEmailWithGoogle();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value),
          ),
        );
      },
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
            if (!snapshot.data.contains('google.com')) _buildGoogleLinkButton(),
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
