import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProfileSettingsButton extends StatelessWidget {
  final bool belongsToUserInSession;

  const ProfileSettingsButton({
    Key key,
    @required this.belongsToUserInSession,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return belongsToUserInSession
        ? IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      // height: 330,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            texts.editProfile,
                            textAlign: TextAlign.center,
                          ),
                          // dense: true,
                          onTap: () {
                            // UserProfileNotifier userProfileNotifier =
                            //     Provider.of<UserProfileNotifier>(context, listen: false);
                            // userProfileNotifier.userProfile = null;
                            Navigator.pushReplacementNamed(context, profileRoute);
                          },
                        ),
                        Divider(
                          thickness: 1,
                          height: 5,
                        ),
                        ListTile(
                          title: Text(
                            texts.support,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, supportRoute);
                          },
                        ),
                        Divider(
                          thickness: 1,
                          height: 5,
                        ),
                        ListTile(
                          title: Text(
                            texts.settings,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, settingsRoute);
                          },
                        ),
                        Divider(thickness: 1),
                        ListTile(
                          title: Text(
                            texts.signOut,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () async {
                            if (await context
                                .read<AuthenticationService>()
                                .signOut(context: context)) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, signInRoute, (Route<dynamic> route) => false);
                            }
                          },
                        ),
                        Divider(thickness: 1),
                        ListTile(
                          title: Text(
                            texts.close,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          )
        : Container(width: 24);
  }
}
