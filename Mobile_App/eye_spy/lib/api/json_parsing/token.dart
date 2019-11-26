import 'dart:convert';

Key keyFromJson(String str) => Key.fromJson(json.decode(str));

class Key {
    String key;

    Key({
        this.key,
    });

    factory Key.fromJson(Map<String, dynamic> json) => Key(
        key: json["key"],
    );
}
