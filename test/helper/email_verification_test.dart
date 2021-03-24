import 'package:app/middleware/firebase/email_verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserMock extends Mock implements User {}

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

main () {
  final emailTest = 'test@mail.com';

  UserMock userMock;
  FirebaseAuthMock firebaseAuthMock;
  EmailVerification emailVerification;

  test('Given no current user in FirebaseAuth EmailVerification returns null', () async {
    firebaseAuthMock = FirebaseAuthMock();

    when(firebaseAuthMock.currentUser).thenReturn(null);
    emailVerification = EmailVerification(firebaseAuthMock);
    
    expect(await emailVerification.sendVerificationEmail(), userMock);
  });

  test('Given a current user in FirebaseAuth EmailVerification returns the user', () async {
    userMock = UserMock();
    firebaseAuthMock = FirebaseAuthMock();

    when(userMock.email).thenReturn(emailTest);
    when(firebaseAuthMock.currentUser).thenReturn(userMock);
    emailVerification = EmailVerification(firebaseAuthMock);
    
    expect(await emailVerification.sendVerificationEmail(), userMock);
  });

  test('Given a null user and parsing that to EmailVerification returns null', () async {
    userMock = null;
    var firebaseAuthMock = FirebaseAuthMock();

    when(firebaseAuthMock.currentUser).thenReturn(userMock);
    emailVerification = EmailVerification(firebaseAuthMock);

    expect(await emailVerification.sendVerificationEmail(user:userMock), null);
  });

  test('Given a user parsed to EmailVerification returns user with verified email', () async {
    userMock = UserMock();
    firebaseAuthMock = FirebaseAuthMock();

    when(userMock.email).thenReturn(emailTest);
    when(firebaseAuthMock.currentUser).thenReturn(userMock);
    emailVerification = EmailVerification(firebaseAuthMock);
    
    expect(await emailVerification.sendVerificationEmail(user: userMock), userMock);
  });  
}