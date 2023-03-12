// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserModel {
//   static const NUMBER = "number";
//   static const ID = "id";

//   String _number;
//   String _id;

// //  getters
//   String get number => _number;
//   String get id => _id;

//   UserModel.fromSnapshot(DocumentSnapshot snapshot) {
//     _number = snapshot.data[NUMBER];
//     _id = snapshot.data[ID];
//   }
// }

class UserModel {
  String id;
  String number;

  UserModel({
    this.id = '',
    required this.number,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        number: json['number'],
      );
}
