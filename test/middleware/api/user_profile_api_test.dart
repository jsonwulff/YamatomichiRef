import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../firebase/setup_firebase_auth_mock.dart';

class FirebaseMock extends Mock implements Firebase {}

@GenerateMocks([])
main() {
  setupFirebaseAuthMocks();
  UserProfileNotifier userProfileNotifier;

  setUpAll(() async {
    await Firebase.initializeApp();
    userProfileNotifier = UserProfileNotifier();
  });

  group('isAdmin', () {
    test(
        'Given a non administrator userprofile isAdmin updates the userprofile in notifier with false',
        () async {
      UserProfile userProfile = UserProfile(roles: {'administrator': false});
      final ffMock = MockFirestoreInstance();
      final store = ffMock.collection('userProfiles');
      await store.add(userProfile.toMap());
      var snaps = await ffMock.collection('userProfiles').get();
      store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
      userProfile.id = snaps.docs.first.id;

      changeSource(ffMock);

      userProfileNotifier.userProfile = userProfile;

      //isAdmin(userProfile.id, userProfileNotifier);

      expect(userProfileNotifier.userProfile.roles['administrator'], false);
    });

    test('Given an administrator userprofile isAdmin updates the userprofile in notifier with true',
        () async {
      UserProfile userProfile = UserProfile(roles: {'administrator': true});
      final ffMock = MockFirestoreInstance();
      final store = ffMock.collection('userProfiles');
      await store.add(userProfile.toMap());
      var snaps = await ffMock.collection('userProfiles').get();
      store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
      userProfile.id = snaps.docs.first.id;

      changeSource(ffMock);

      userProfileNotifier.userProfile = userProfile;

      //isAdmin(userProfile.id, userProfileNotifier);

      expect(userProfileNotifier.userProfile.roles['administrator'], true);
    });
  });
}
