import 'dart:async';
import 'dart:io';
import 'package:eye_spy/api/api_layer.dart';
import 'package:eye_spy/api/json_parsing/json_parsers.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:eye_spy/authentication/authentication.dart';
import './bloc.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  final AuthenticationBloc authenticationBloc;

  ApiBloc({@required this.authenticationBloc})
      : assert(authenticationBloc != null);

  @override
  ApiState get initialState => ApiUninitialized();

  @override
  Stream<ApiState> mapEventToState(
    ApiEvent event,
  ) async* {
    if (event is ApiLoadCameras) {
      print(authenticationBloc.userRepository.getToken());
      List<ListTile> cameraTiles = await buildCameraList(
        authenticationBloc.userRepository.getToken(),
        this,
      );
      yield ApiSelectCamera(cameraTiles: cameraTiles);
    }
    if (event is ApiCameraSelected) {
      File video = await ApiLayer.cameraRequest(
          authenticationBloc.userRepository.getToken(), event.camId);
      yield ApiWatchCamera(
          camId: event.camId, camName: event.camName, video: video);
    }
  }
}

Future<List<ListTile>> buildCameraList(String token, ApiBloc apiBloc) async {
  List<Cameras> cameras = await ApiLayer.cameraListRequest(token);

  return cameras.map((camera) => buildCameraTile(camera, apiBloc)).toList();
}

ListTile buildCameraTile(Cameras camera, ApiBloc apiBloc) {
  return ListTile(
    title: Text(camera.name),
    leading: Icon(Icons.videocam),
    onTap: () {
      apiBloc.add(ApiCameraSelected(camId: camera.id, camName: camera.name));
    },
  );
}
