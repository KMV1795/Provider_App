import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider_app/view_screens/qr_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/login_model.dart';
import '../Model/user_model.dart';
import '../Utils/utils.dart';
import 'common_services.dart';
import 'login_details_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  String _userToken = '';
  String get userToken => _userToken;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _uid;
  String get uid => _uid!;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  String _verificationId = '';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AuthProvider() {
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    _isSignedIn = preferences.getBool("is_signedIn") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("is_signedIn", true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    _userToken = preferences.getString("user_token") ?? '';
    notifyListeners();
  }

  Future setToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("user_token", _userToken);
    _userToken = _userToken;
    notifyListeners();
  }

  // SignIn
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
            notifyListeners();
            // ignore: use_build_context_synchronously
            showSnackBar(context, 'Phone Number Verfied Successfully');
          },
          verificationFailed: (error) {
            if (kDebugMode) {
              print('Verification failed: $error');
            }
            showSnackBar(context, 'Verification failed: $error');
          },
          codeSent: (verificationId, forceResendingToken) {
            _verificationId = verificationId;
            notifyListeners();
            showSnackBar(context, 'OTP sent Successfully');
          },
          codeAutoRetrievalTimeout: (verificationId) {
            _verificationId = verificationId;
            notifyListeners();
          });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // verify otp
  void verifyOtp({
    required BuildContext context,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: userOtp);

      User? user =
          (await _firebaseAuth.signInWithCredential(phoneAuthCredential)).user;

      if (user != null) {
        // carry our logic
        _uid = user.uid;
        // ignore: use_build_context_synchronously
        await loginUser(context);
        onSuccess();
      }
      // ignore: use_build_context_synchronously
      showSnackBar(context, "Login Details Saved Successfully");
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // DATABASE OPERATIONS
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      if (kDebugMode) {
        print("USER EXISTS");
      }
      return true;
    } else {
      if (kDebugMode) {
        print("NEW USER");
      }
      return false;
    }
  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        uid: snapshot['uid'],
        phoneNumber: snapshot['phoneNumber'],
        createdAt: snapshot['createdAt'],
      );
      _uid = userModel.uid;
    });
  }

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  Future userSignOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    prefs.clear();
  }

  // Login Function after verification

  Future loginUser(BuildContext context) async {
    String loginTime = CommonService().getLoginTime();
    String loginDate = CommonService().getLoginDate();
    Position position;
    position = await CommonService().getLocation();
    String location = await CommonService().getAddressFromLatLong(position);
    String ipAddress = await CommonService().getIpAddress();
    final loginModel = LoginModel(
      time: loginTime,
      date: loginDate,
      ip: ipAddress,
      location: location,
      url: "",
    );
    // ignore: use_build_context_synchronously
    bool result = await UserService().saveUserDetails(loginModel, context);
    result == true
        ?
        // ignore: use_build_context_synchronously
        showSnackBar(context, "Login Details saved Successfully")
        // ignore: use_build_context_synchronously
        : showSnackBar(context, "Login Details not saved");
    return result == true
        ?
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QrPage(
                ip: ipAddress,
                location: location,
                loginTime: loginTime,
                loginDate: loginDate,
              ),
            ),
          )
        // ignore: use_build_context_synchronously
        : false;
  }
}
