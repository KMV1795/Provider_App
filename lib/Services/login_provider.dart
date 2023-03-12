import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _verificationId = '';
  UserCredential? _userCredential;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future verifyPhoneNumber(String phoneNumber) async {
    try {
      verificationCompleted(PhoneAuthCredential authCredential) async {
        _userCredential =
            await _firebaseAuth.signInWithCredential(authCredential);
        notifyListeners();
      }

      verificationFailed(FirebaseAuthException authException) {
        if (kDebugMode) {
          print('Verification failed: $authException');
        }
      }

      codeSent(String verificationId, [int? forceResendingToken]) {
        _verificationId = verificationId;
        notifyListeners();
      }

      codeAutoRetrievalTimeout(String verificationId) {
        _verificationId = verificationId;
        notifyListeners();
      }

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to verify phone number: $e');
      }
    }
  }

  Future<void> signInWithPhoneNumber(String smsCode) async {
    try {
      final AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      _userCredential =
          await _firebaseAuth.signInWithCredential(authCredential);
      if (_userCredential!.user != null) {
        _isLoggedIn = true;
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to sign in with phone number: $e');
      }
      _isLoggedIn = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _userCredential = null;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to sign out: $e');
      }
    }
  }
}
