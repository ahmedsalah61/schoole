class LoginModel {
  String? token;
  User? user;

  LoginModel({this.token, this.user});

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}

class User {
  String? id;
  String? name;
  String? email;
  String? role;
  String? gender;
  String? phoneNumber;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.gender,
    this.phoneNumber,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    gender = json['gender'];
    phoneNumber = json['phone_number'];
  }
}

class LogoutModel {
  bool? status;
  String? message;

  LogoutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}