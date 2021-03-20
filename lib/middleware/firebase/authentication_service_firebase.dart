import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../ui/components/pop_up_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  // FirebaseAuth.instance
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  User get user => _firebaseAuth.currentUser;

  Future<bool> signOut(BuildContext context) async {
    if (_firebaseAuth.currentUser != null) {
      if (await simpleChoiceDialog(
          context, 'Are you sure you want to sign out?')) {
        await _firebaseAuth.signOut();
        return true;
      }
    }
    return false;
  }

  Future<String> signUpUserWithEmailAndPassword(
      {String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Create a userProfile
      // TODO Consider set first name and last name here
      UserProfile userProfile = UserProfile();
      User user = _firebaseAuth.currentUser;
      userProfile.id = user.uid;
      userProfile.email = user.email;
      userProfile.createdAt = Timestamp.now();
      userProfile.updatedAt = Timestamp.now();
      CollectionReference userProfiles =
          FirebaseFirestore.instance.collection('userProfiles');
      await userProfiles
          .doc(_firebaseAuth.currentUser.uid)
          .set(userProfile.toMap());
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email';
      } else if (e.code == 'email-invalid') {
        return 'The email is not valid';
      }
      return e.message;
    }
  }

  Future<String> signInUserWithEmailAndPassword(
      {String email,
      String password,
      UserProfileNotifier userProfileNotifier}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      String userUid = _firebaseAuth.currentUser.uid;
      getUserProfile(userUid, userProfileNotifier);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'The email is not valid';
      } else if (e.code == 'user-disabled') {
        return 'This user account has been disabled';
      } else if (e.code == 'user-not-found') {
        return 'There is no user corresponding to the given email';
      } else if (e.code == 'wrong-password') {
        return 'Email or password was wrong';
      }
      return e.message;
    }
  }

  Future<String> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.additionalUserInfo.isNewUser) {
        UserProfile userProfile = UserProfile();
        userProfile.id = user.uid;
        userProfile.email = user.email;
        userProfile.imageUrl = user.photoURL;
        userProfile.createdAt = Timestamp.now();
        userProfile.updatedAt = Timestamp.now();
        CollectionReference userProfiles =
            FirebaseFirestore.instance.collection('userProfiles');
        await userProfiles
            .doc(_firebaseAuth.currentUser.uid)
            .set(userProfile.toMap());
      }

      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return 'The account already exists with a different credential';
      } else if (e.code == 'invalid-credential') {
        return 'Error occurred while accessing credentials. Try again.';
      }
      return e.message;
    }
  }
}
