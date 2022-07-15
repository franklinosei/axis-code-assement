import 'dart:convert';

AuthResponse authResponseFromJson(String str) =>
    AuthResponse.fromJson(json.decode(str)["response"]);

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  AuthResponse({
    this.message,
    this.token,
  });

  String? message;
  String? token;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json["message"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
      };
}
