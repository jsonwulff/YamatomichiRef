// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file at:
// https://github.com/FirebaseExtended/flutterfire/blob/master/LICENSE

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    if (call.method == 'DocumentReference#update') {
      return {
        'firestore': call.arguments['firestore'],
        'reference': call.arguments['reference'],
        'data': call.arguments['data'],
        'pluginConstants': {},
      };
    }

    if (call.method == 'DocumentReference#get') {
      return {
        'firestore': call.arguments['firestore'],
        'reference': call.arguments['reference'],
        'source': call.arguments['source'],
        'pluginConstants': {},
      };
    }

    // if (customHandlers != null) {
    //   customHandlers(call);
    // }

    return null;
  });
}

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}
