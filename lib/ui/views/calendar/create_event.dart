import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/event.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'components/create_event_stepper.dart';
import 'components/event_controllers.dart'; // Use localization

class CreateEventView extends StatefulWidget {
  CreateEventView({Key key}) : super(key: key);

  @override
  _CreateEventViewState createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  Event event;
  EventNotifier eventNotifier;
  UserProfileNotifier userProfileNotifier;
  UserProfileService userProfileService = UserProfileService();
  bool editing = false;

  @override
  void initState() {
    super.initState();
    eventNotifier = Provider.of<EventNotifier>(context, listen: false);
    event = eventNotifier.event;
    if (event != null) {
      editing = true;
      EventControllers(event);
    }
    userProfileNotifier = Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      String userUid = context.read<AuthenticationService>().user.uid;
      userProfileService.getUserProfileAsNotifier(userUid, userProfileNotifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          elevation: 0,
          title: Text(
            editing ? 'Edit event' : texts.createNewEvent,
            style: Theme.of(context).textTheme.headline1,
          ),
          // backgroundColor: Colors.white,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              EventControllers.dispose();
              Navigator.of(context).pop(); //...todo fix navigation
              EventControllers.updated = false;
            },
          )),
      body: StepperWidget(
        event: event,
        eventNotifier: eventNotifier,
        editing: editing,
      ),
    );
  }
}
