import 'dart:async';
import 'dart:convert';

import 'package:blog_api_app/constants.dart';
import 'package:blog_api_app/helpers/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _loginUser(String username, String password) async {
    final http.Response response = await http.post(
      '$apiAccountUrl/login/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      _token = responseData['token'];
      _userId = responseData['id'];
      _expiryDate = DateTime.now().add(
          Duration(seconds: double.parse(responseData['expires_in']).round()));
      _autoLogout();
      notifyListeners();

      final _prefs = await SharedPreferences.getInstance();
      final _userData = json.encode({
        "token": _token,
        "id": _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      _prefs.setString('userData', _userData);
    } else {
      final errorData = jsonDecode(response.body);
      print(errorData);
      throw HttpExceptionHelper(errorData['error_message']);
    }
  }

  Future<void> _createUser(
    String email,
    String username,
    String password,
    String password2,
    String timestamp,
  ) async {
    final response = await http.post(
      '$apiAccountUrl/register/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'username': username,
        'password': password,
        'password2': password2,
        'timestamp': timestamp,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print(responseData);
      notifyListeners();
    } else {
      final errorData = jsonDecode(response.body);
      print(errorData);
      throw HttpExceptionHelper(errorData['error_message']);
    }
  }

  Future<void> login(String username, String password) async {
    return _loginUser(username, password);
  }

  Future<void> register(String email, String username, String password,
      String password2, String timestamp) async {
    return _createUser(email, username, password, password2, timestamp);
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['id'];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
