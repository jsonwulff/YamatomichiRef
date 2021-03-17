import 'package:firebase_auth/firebase_auth.dart';

class EmailVerification {
  final FirebaseAuth _firebaseAuth;

  EmailVerification(this._firebaseAuth);

  /// TODO
  Future<User> sendVerificationEmail({User user}) async {
    if (user == null) user = _firebaseAuth.currentUser;

    if (user != null) {
      await user.sendEmailVerification();
      await user.reload();
    } 

    return user;
  }
}