class UserModel {
  String username;

  String email;
  String password;
  String mobile;

  String uid;


  UserModel({
    required this.username,

    required this.email,
    required this.password,
    required this.mobile,

    required this.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        username: json['username'],

        email: json['email'],
        password: json['password'],
        mobile: json['mobile'],

        uid: json['uid']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;

    data['email'] = email;
    data['password'] = password;
    data['mobile'] = mobile;

    data['uid'] = uid;
    return data;
  }
}

class CurrUser {
  static String? username;

  static String? email;
  static String? password;
  static String? mobile;
  static String? uid;

}