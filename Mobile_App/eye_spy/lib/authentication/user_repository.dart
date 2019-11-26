 
import 'dart:async';

import 'package:eye_spy/api/api_layer.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  String token;

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    token = await ApiLayer.loginRequest(username, password);
    
    return token;
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    final prefs = await SharedPreferences.getInstance();
    token = null;
    prefs.remove('token');
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token');

    if (token == null) return false;
    return true;
  }

  String getToken () {
    return token;
  }
}