import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String accessToken;
  String email;
  String password;

  LoginModel({required this.accessToken, required this.email, required this.password});

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      LoginModel(accessToken: json["accessToken"] ?? "", email: json["email"] ?? "", password: json["password"]);

  Map<String, dynamic> toJson() => {"accessToken": accessToken, "email": email, "password": password};
}
