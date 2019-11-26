import 'package:eye_spy/api/bloc/bloc.dart';
import 'package:eye_spy/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eye_spy/authentication/authentication.dart';

class BasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) {
        return ApiBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        )..add(ApiLoadCameras());
      },
      child: _BasePage(),
    );
  }
}

class _BasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, ApiState>(
      builder: (context, state) {
        if (state is ApiSelectCamera) {
          return SelectCamPage(cameraTiles: state.cameraTiles);
        }
        if (state is ApiWatchCamera) {
          return WatchCamPage(
            camId: state.camId,
            camName: state.camName,
            video: state.video,
          );
        }
        return LoadingIndicator();
      },
    );
  }
}
