import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import 'package:eye_spy/api/api.dart';

class WatchCamPage extends StatefulWidget {
  final String camName;
  final int camId;
  final File video;

  WatchCamPage({
    @required this.camId,
    @required this.camName,
    @required this.video,
    Key key,
  }) : super(key: key);

  @override
  WatchCamPageState createState() => WatchCamPageState();
}

class WatchCamPageState extends State<WatchCamPage> {
  ChewieController _chewieController;
  VideoPlayerController playerController;
  @override
  void initState() {
    playerController = VideoPlayerController.file(widget.video);
    super.initState();
    _chewieController = _createVideo();
  }

  ChewieController _createVideo() {
    return ChewieController(
      videoPlayerController: playerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: true,
      autoPlay: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(
              color: Colors.white,  
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        BlocProvider.of<ApiBloc>(context).add(ApiLoadCameras());
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.camName),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                BlocProvider.of<ApiBloc>(context).add(ApiLoadCameras());
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Chewie(controller: _chewieController),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
    _chewieController.dispose();
  }
}
