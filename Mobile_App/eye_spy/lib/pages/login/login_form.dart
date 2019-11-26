import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eye_spy/authentication/authentication.dart';
import 'package:flushbar/flushbar.dart';

class LoginForm extends StatefulWidget {
  final String errorMessage;

  LoginForm({Key key, this.errorMessage}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Flushbar(
          message: widget.errorMessage,
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      BlocProvider.of<AuthenticationBloc>(context).add(
        LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }

    return SingleChildScrollView(
      child: Form(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(64.0, 8.0, 64.0, 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.lightGreen,
                  child: Image.asset(
                    'lib/assets/logo.png',
                  ),
                ),
              ),
              TextFormField(
                focusNode: _usernameFocusNode,
                decoration: InputDecoration(labelText: 'username'),
                controller: _usernameController,
                onFieldSubmitted: (term) {
                  _usernameFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              TextFormField(
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(labelText: 'password'),
                controller: _passwordController,
                obscureText: true,
                onFieldSubmitted: (term) {
                  _passwordFocusNode.unfocus();
                  _onLoginButtonPressed();
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(48.0, 16.0, 48.0, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: _onLoginButtonPressed,
                    child: Text('Login'),
                    color: Colors.lightGreen,
                  ),
                ),
              ),
              Divider(
                thickness: 5,
                color: Colors.lightGreen,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(48.0, 16.0, 48.0, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text('Login with Google'),
                    color: Colors.lightGreen[200],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
