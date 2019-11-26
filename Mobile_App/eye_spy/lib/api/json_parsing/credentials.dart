import 'dart:convert';

String credentialsToJson(Credentials data) => json.encode(data.toJson());

class Credentials {
    String username;
    String password;

    Credentials({
        this.username,
        this.password,
    });

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
    };
}
