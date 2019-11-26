import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

abstract class ApiState extends Equatable {
  const ApiState();

  @override
  List<Object> get props => [];
}

class ApiUninitialized extends ApiState {}

class ApiSelectCamera extends ApiState {
  final List<ListTile> cameraTiles;

  const ApiSelectCamera({
    @required this.cameraTiles,
  });

  @override
  List<Object> get props => [cameraTiles];

  @override
  String toString() => 'ApiSelectCamera';
}

class ApiWatchCamera extends ApiState {
  final String camName;
  final int camId;
  final File video;

  const ApiWatchCamera({
    @required this.camName,
    @required this.camId,
    @required this.video,
  });

  @override
  List<Object> get props => [camName, camId, video];

  @override
  String toString() => 'ApiWatchCamera { camName: $camName , camId: $camId }';
}
