import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../ui/components/pop_up_dialog.dart';

class AuthenticationService {
  // FirebaseAuth.instance
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  User get user => _firebaseAuth.currentUser;

  Future<void> signOut(BuildContext context) async {
    if (_firebaseAuth.currentUser != null) {
      if (await signOutDialog(context)) {
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
      CollectionReference userProfiles =
          FirebaseFirestore.instance.collection('userProfiles');
      await userProfiles
          .doc(user.uid)
          .set({'UserUID': _firebaseAuth.currentUser.uid});
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
      {String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // user = _firebaseAuth.currentUser;
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
}
