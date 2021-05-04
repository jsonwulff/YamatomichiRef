import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class AuthenticationService {
  // FirebaseAuth.instance
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  FirebaseAuth get firebaseAuth => _firebaseAuth;

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  User get user => _firebaseAuth.currentUser;

  // Future<List<String>> get loginMethods => async {
  //    await this.firebaseAuth.fetchSignInMethodsForEmail(this.user.email);
  // }

  Future<bool> signOut({BuildContext context}) async {
    if (_firebaseAuth.currentUser != null) {
      if (await simpleChoiceDialog(
          context,
          context != null
              ? AppLocalizations.of(context).areYouSureYouWantToLogout
              : 'Are you sure you want to log out?')) {
        await _firebaseAuth.signOut();
        return true;
      }
    }
    return false;
  }

  Future<void> forceSignOut(BuildContext context) async {
    if (_firebaseAuth.currentUser != null) await _firebaseAuth.signOut();
  }

  /// Assumes that [email] is a valid email, only checks for null and empty strings.
  /// If it is so a FormatException is thrown
  Future<void> sendResetPasswordLink(BuildContext context, String email) async {
    if (email == null || email.isEmpty) {
      throw FormatException('Invalid string', email);
    } else {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    }
  }

  Future<String> signUpUserWithEmailAndPassword(
      {BuildContext context,
      String firstName,
      String lastName,
      String email,
      String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Create a userProfile
      // TODO Consider to use user.metaData
      User user = this.user;
      UserProfile userProfile = UserProfile();
      userProfile.id = user.uid;
      userProfile.firstName = firstName;
      userProfile.lastName = lastName;
      userProfile.email = user.email;
      userProfile.createdAt = Timestamp.now();
      userProfile.updatedAt = Timestamp.now();
      userProfile.isBanned = false;
      userProfile.bannedMessage = "";
      userProfile.roles = {'ambassador': false, 'yamatomichi': false};
      CollectionReference userProfiles =
          FirebaseFirestore.instance.collection('userProfiles');
      await userProfiles
          .doc(_firebaseAuth.currentUser.uid)
          .set(userProfile.toMap());
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return (context != null)
            ? AppLocalizations.of(context).thePasswordProvidedIsTooWeak
            : "The password provided is too weak";
      } else if (e.code == 'email-already-in-use') {
        return (context != null)
            ? AppLocalizations.of(context).anAccountWithThatEmailAlreadyExists
            : "An account with that email already exists";
      } else if (e.code == 'email-invalid') {
        return (context != null)
            ? AppLocalizations.of(context).thisEmailIsNotValid
            : "This email is not valid";
      }
      return e.message;
    }
  }

  Future<String> signInUserWithEmailAndPassword(
      {BuildContext context,
      String email,
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
        return (context != null)
            ? AppLocalizations.of(context).thisEmailIsNotValid
            : "This email is not valid";
      } else if (e.code == 'user-disabled') {
        return (context != null)
            ? AppLocalizations.of(context).thisUserAccountHasBeenDisabled
            : "This user account has been disabled";
      } else if (e.code == 'user-not-found') {
        return (context != null)
            ? AppLocalizations.of(context)
                .thereIsNoUserCorrespondingToTheGivenEmail
            : "There is no user corresponding to the given email";
      } else if (e.code == 'wrong-password') {
        return (context != null)
            ? AppLocalizations.of(context).emailOrPasswordWasWrong
            : "Email or password was wrong";
      }
      return e.message;
    }
  }

  Future<String> signInWithGoogle({BuildContext context}) async {
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

      // TODO check that this doesn't override login with email if the mail is confirmed.
      if (userCredential.additionalUserInfo.isNewUser) {
        // Create new UserProfile
        UserProfile userProfile = UserProfile();
        // Get google account
        User user = userCredential.user;
        // Set UserProfileData
        List<String> name = user.displayName.split(" ");
        userProfile.id = user.uid;
        userProfile.firstName = name[0];
        userProfile.lastName =
            name.length > 1 ? name.sublist(1).join(" ") : null;
        userProfile.email = user.email;
        userProfile.imageUrl = user.photoURL;
        userProfile.createdAt = Timestamp.now();
        userProfile.updatedAt = Timestamp.now();
        // Upsert UserProfile in firestore
        CollectionReference userProfiles =
            FirebaseFirestore.instance.collection('userProfiles');
        await userProfiles
            .doc(_firebaseAuth.currentUser.uid)
            .set(userProfile.toMap());
      }
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return context != null
            ? AppLocalizations.of(context)
                .accountAlreadyExistsWithDifferentCredentials
            : 'Account already exists with different credentials';
      } else if (e.code == 'invalid-credential') {
        return context != null
            ? AppLocalizations.of(context).errorWhileAccessingCreds
            : 'Error while accessing credentials';
      }
      return e.message;
    }
  }

  Future<String> linkEmailWithGoogle({BuildContext context}) async {
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

    // TODO make error messages
    User user = this.user;
    try {
      // ignore: unused_local_variable
      final UserCredential userCredential =
          await user.linkWithCredential(credential);
      return context != null
          ? AppLocalizations.of(context).accountsSuccesfullyLinked
          : 'Accounts succesfully linked';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
      } else if (e.code == 'invalid-credential') {
      } else if (e.code == 'credential-already-in-use') {
      } else if (e.code == 'email-already-in-use') {}
      return e.message;
    }
  }

  // TODO handle reauthenticateWithCredential before updating password
  Future<String> changePassword(newPassword) async {
    User user = this.user;

    try {
      await user.updatePassword(newPassword);
      return 'Password changed';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'requires-recent-login') {}
      return e.message;
    }
  }
}
