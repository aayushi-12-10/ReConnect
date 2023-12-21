class UserModel {
  String? email;
  String? role;
  String? uid;
  bool isVerified;
  String? name;
  String? rollNumber;

  UserModel({
    this.uid,
    this.email,
    this.role,
    this.isVerified = false,
    this.name,
    this.rollNumber,
  });

  // sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'isVerified': isVerified,
      'name': name,
      'rollNumber': rollNumber,
    };
  }

  // receiving data
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      isVerified: map['isVerified'],
      name: map['name'],
      rollNumber: map['rollNumber'],
    );
  }
}
