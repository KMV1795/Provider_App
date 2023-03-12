// ignore_for_file: use_build_context_synchronously,

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Model/login_model.dart';
import 'common_services.dart';

class UserService {
  final FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;
  final user = FirebaseFirestore.instance.collection('users');

  bool added = false;

  String loginTime = CommonService().getLoginTime();
  String loginDate = CommonService().getLoginDate();
  String preDate = CommonService().getYesterdayDate();

  Stream<List<LoginModel>> todayLogin() => FirebaseFirestore.instance
      .collection('users')
      .doc(user.id)
      .collection('loginDetails')
      .where('date', isEqualTo: loginDate)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => LoginModel.fromJson(doc.data())).toList());

  Stream<List<LoginModel>> preLogin() => FirebaseFirestore.instance
      .collection('users')
      .doc(user.id)
      .collection('loginDetails')
      .where('date', isEqualTo: preDate)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => LoginModel.fromJson(doc.data())).toList());

  Stream<List<LoginModel>> otherLogin() => FirebaseFirestore.instance
      .collection('users')
      .doc(user.id)
      .collection('loginDetails')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => LoginModel.fromJson(doc.data())).toList());

  Future saveUserDetails(
    LoginModel loginModel,
    BuildContext context,
  ) async {
    final user = _firebaseFireStore.collection('users');
    final docUser = user.doc(user.id).collection('loginDetails').doc();
    loginModel.id = docUser.id;
    final json = loginModel.toJson();

    try {
      await docUser.set(json);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User Ip Address and Location Added Sucessfully"),
      ));
      added = true;
      return added;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User Ip Address and Location Not Saved \n$e"),
      ));
      added = false;
      return added;
    }
  }
}
