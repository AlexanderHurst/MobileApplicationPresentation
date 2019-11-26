import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ApiEvent extends Equatable {
  const ApiEvent();

  @override
  List<Object> get props => [];
}

class ApiLoadCameras extends ApiEvent {}

class ApiCameraSelected extends ApiEvent {
  final int camId;
  final String camName;

  const ApiCameraSelected({
    @required this.camId,
    @required this.camName,
  });

  @override
  List<Object> get props => [camId];

  @override
  String toString() =>
      'ApiCameraSeleceted { camName: $camName, camId: $camId }';
}
