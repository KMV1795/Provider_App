
class UserModel {
  String phoneNumber;
  String uid;
  String createdAt;

  UserModel({
    required this.phoneNumber,
    required this.uid,
    required this.createdAt,
  });

  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
    };
  }
}
