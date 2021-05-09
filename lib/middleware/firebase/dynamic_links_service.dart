// https://stackoverflow.com/questions/58481840/flutter-how-to-pass-custom-arguments-in-firebase-dynamic-links-for-app-invite
import 'package:app/ui/views/unknown.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  static Future<String> generateResetPasswordDynamicLink(String email) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://yamatomichi.page.link',
        link: Uri.parse('https://yamatomichi.page.link.com/reset-password?email=$email'),
        // link: Uri.parse('https://yamatomichi.page.link.com/?id=$email'),
        androidParameters: AndroidParameters(
          packageName: 'com.yamatomichi.app',
          minimumVersion: 1,
        ),
        // iosParameters: IosParameters(
        //   bundleId: 'your_ios_bundle_identifier',
        //   minimumVersion: '1',
        //   appStoreId: 'your_app_store_id',
        // ),
      );
      // final Uri dynamicUrl = await parameters.buildUrl();
      // return dynamicUrl.toString();

      var dynamicUrl = await parameters.buildShortLink();
      final Uri shortUrl = dynamicUrl.shortUrl;
      return shortUrl.toString();
  }

  Future handleDynamicLinks() async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // 2. handle link that has been retrieved
    _handleDeepLink(data);

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      // 3a. handle link that has been retrieved
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {

      print('_handleDeepLink | deeplink: $deepLink');
    }
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
  try {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    print(
      '''
      
      
      
      HERE
      
      
      
      
      '''

      + deepLink.toString()

    );

    if (deepLink != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => UnknownPage()));
    }

    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => UnknownPage()));
    });

  } catch (e) {
    print(e.toString());
  }
}
}
