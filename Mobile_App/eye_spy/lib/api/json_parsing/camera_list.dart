import 'dart:convert';

List<Cameras> cameraListFromJson(String str) => List<Cameras>.from(json.decode(str).map((x) => Cameras.fromJson(x)));

// currently unused
String cameraListToJson(List<Cameras> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cameras {
    int org;
    int account;
    String address;
    String name;
    int id;

    Cameras({
        this.org,
        this.account,
        this.address,
        this.name,
        this.id,
    });

    factory Cameras.fromJson(Map<String, dynamic> json) => Cameras(
        org: json["org"],
        account: json["account"],
        address: json["address"],
        name: json["name"],
        id: json["id"],
    );

    // currently unused
    Map<String, dynamic> toJson() => {
        "org": org,
        "account": account,
        "address": address,
        "name": name,
        "id": id,
    };
}
