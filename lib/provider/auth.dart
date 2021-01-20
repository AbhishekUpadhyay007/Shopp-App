import 'dart:convert';
import 'dart:async';

import '../models/HttpException.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String userId;
  DateTime expiryDate;
  Timer authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_token != null &&
        expiryDate.isAfter(DateTime.now()) &&
        expiryDate != null) {
      return _token;
    }
    return null;
  }

  Future<void> authenticate(String email, String password, String auth) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$auth?key=AIzaSyCPmF_LuXBmyOQEh3XLsXCwvAxZlUXS-xQ";

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      userId = responseData['localId'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      autoLogOut();
      notifyListeners();

      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': userId,
        'token' : _token,
        'expiry': expiryDate.toIso8601String()
      });

      pref.setString('userData', userData);
    
    } catch (error) {
      throw error;
    }
  }

  Future<void> logIn(String email, String password) async {
    return authenticate(email, password, "signInWithPassword");
  }

  Future<void> signUp(String email, String pass) async {
    return authenticate(email, pass, "signUp");
  }

  Future<bool> tryLogin() async{
    final pref = await SharedPreferences.getInstance();
    if(!pref.containsKey('userData')){
      return false;
    }
    final extractedData = json.decode(pref.getString('userData')) as Map<String, Object>;
    DateTime expireTime = DateTime.parse(extractedData['expiry']);
    
    if(expireTime.isBefore(DateTime.now())){
      return false;
    }

    _token = extractedData['token'];
    userId = extractedData['userId'];
    expiryDate = expireTime;
    notifyListeners();
    autoLogOut();
    return true;

  }

    Future<void> logOut() async {
    _token = null;
    userId = null;
    expiryDate = null;
    if(authTimer!=null){
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    // pref.remove('userData');
    pref.clear();
  }

  void autoLogOut() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    final timeOfExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeOfExpiry), logOut);
  }
}
