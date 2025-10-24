// class UserModel {
//   String? message;
//   String? token;
//   String? expiresIn;
//   User? user;
//
//
//
//   UserModel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     token = json['token'];
//     expiresIn = json['expiresIn'];
//     user = json['user'] != null ?  User.fromJson(json['user']) : null;
//   }
//
//
// }
//
// class User {
//   int? id;
//   String? firstName;
//   String? lastName;
//   String? email;
//   String? role;
//   String? gender;
//   String? city;
//   String? academicLevel;
//   String? profileImageUrl;
//
//
//
//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     email = json['email'];
//     role = json['role'];
//     gender = json['gender'];
//     city = json['city'];
//     academicLevel = json['academicLevel'];
//     profileImageUrl = json['profileImageUrl'];
//   }
//
//
// }

class UserModel {
  String? message;
  String? token;
  String? expiresIn;
  User? user;


  UserModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    expiresIn = json['expiresIn'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

}

class User {
  int? id;
  String? fullName;
  String? email;
  String? role;
  String? gender;
  String? city;
  String? academicLevel;
  String? profileImageUrl;


  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    role = json['role'];
    gender = json['gender'];
    city = json['city'];
    academicLevel = json['academicLevel'];
    profileImageUrl = json['profileImageUrl'];
  }

}