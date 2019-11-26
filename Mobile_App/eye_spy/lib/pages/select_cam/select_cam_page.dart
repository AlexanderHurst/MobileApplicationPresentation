import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:eye_spy/authentication/authentication.dart';
import 'package:eye_spy/api/api.dart';

class SelectCamPage extends StatelessWidget {
  final List<ListTile> cameraTiles;

  SelectCamPage({@required this.cameraTiles, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Logout'),
              content: new Text('Do you want to Logout?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(LoggedOut());
                    return Navigator.of(context).pop(false);
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 24.0),
            child: ListView(
              children: <Widget>[
                Center(
                  child: Text(
                    'VerifEye Security',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.videocam),
                  title: Text("Video"),
                  onTap: () =>
                      BlocProvider.of<ApiBloc>(context).add(ApiLoadCameras()),
                ),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text("Important"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.cloud_upload),
                  title: Text("Upload to server"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text("VerifEye Security"),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Profile Settings"),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text('Cameras'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _onWillPop();
              },
            )
          ],
        ),
        body: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: cameraTiles,
          ).toList(),
        ),
      ),
    );
  }
}
