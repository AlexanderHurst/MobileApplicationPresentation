import 'dart:convert';

Camera cameraFromJson(String str) => Camera.fromJson(json.decode(str));

String cameraToJson(Camera data) => json.encode(data.toJson());

class Camera {
    int cameraId;

    Camera({
        this.cameraId,
    });

    factory Camera.fromJson(Map<String, dynamic> json) => Camera(
        cameraId: json["camera_id"],
    );

    Map<String, dynamic> toJson() => {
        "camera_id": cameraId,
    };
}
