import 'package:app/ui/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';

class DynamicLinkService {
  Future<String> initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        FirebaseAuth auth = FirebaseAuth.instance;

        var actionCode = deepLink.queryParameters['oobCode'];

        try {
          await auth.checkActionCode(actionCode);
          await auth.applyActionCode(actionCode);

          // If successful, reload the user:
          auth.currentUser.reload();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'invalid-action-code') {
            print('''
          
          
          
          
          
          
          
          HERE
          The code is invalid.''');
          }
        }

        if (deepLink != null) {
          print('''
          
          
          
          HERE
          
          
          
          ''' +
              deepLink.toString());
          Navigator.pushNamed(context, changePasswordRoute);
        }
        return changePasswordRoute;
      },
      onError: (OnLinkErrorException e) async {
        // TODO-Lukas: handle error
        print('''
      
      
      
      
      
      
      
      
      
      
      
      
      
      HERE
      onLinkError''');
        print(e.message);
        return changePasswordRoute;
      },
    );
    Navigator.pushNamed(context, changePasswordRoute);
    return null;
  }
}
