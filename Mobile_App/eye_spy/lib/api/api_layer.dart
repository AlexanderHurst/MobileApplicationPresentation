import 'dart:io';

import 'package:eye_spy/api/json_parsing/camera.dart';
import 'package:eye_spy/api/json_parsing/json_parsers.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApiLayer {
  static final String url = "http://192.168.1.175:8080/";

  static Future<String> loginRequest(String username, String password) async {
    var res = await http.post(Uri.encodeFull(url + "login"), headers: {
      "content-type": "application/json",
    }, body: credentialsToJson(Credentials(username: username, password: password)));
    return keyFromJson(res.body).key;
  }

  static Future<List<Cameras>> cameraListRequest(String key) async {
    var res = await http.post(Uri.encodeFull(url + "sources"), headers: {
      "x-api-key": key,
      "content-type": "application/json",
    });
    return cameraListFromJson(res.body);
  }

  static Future<File> cameraRequest(String key, int cameraId) async {

    var res = await http.post(Uri.encodeFull(url + "source"),
        headers: {
          "x-api-key": key,
          "content-type": "application/json",
          "Transfer-Encoding": "chunked",
        },
        body: cameraToJson(Camera(cameraId: cameraId)));

    File file = await _localFile(cameraId.toString() + ".mp4");
    file.writeAsBytes(res.bodyBytes);

    return file;
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  return directory.path;
}

Future<File> _localFile(String fname) async {
  final path = await _localPath;
  return File('$path/$fname');
}
