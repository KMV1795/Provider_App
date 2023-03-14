import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/Services/auth_provider.dart';
import '../Model/login_model.dart';
import 'common_services.dart';

class UserService {
  final user = FirebaseFirestore.instance.collection('users');

  bool _added = false;
  bool get added => _added;

  String loginTime = CommonService().getLoginTime();
  String loginDate = CommonService().getLoginDate();
  String preDate = CommonService().getYesterdayDate();

  getTodayLogin(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(auth.uid)
        .collection('loginDetails')
        .where('date', isEqualTo: loginDate)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LoginModel.fromJson(doc.data()))
            .toList());
  }

  getPreLogin(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(auth.uid)
        .collection('loginDetails')
        .where('date', isEqualTo: preDate)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LoginModel.fromJson(doc.data()))
            .toList());
  }

  getOtherLogin(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(auth.uid)
        .collection('loginDetails')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LoginModel.fromJson(doc.data()))
            .toList());
  }

  Future saveUserDetails(
    LoginModel loginModel,
    BuildContext context,
  ) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final docUser = user.doc(auth.uid).collection('loginDetails').doc();
    loginModel.id = docUser.id;
    final json = loginModel.toJson();
    try {
      _added = false;
      await docUser.set(json);
      _added = true;
      return true;
    } catch (e) {
      _added = false;
      return false;
    }
  }
}
