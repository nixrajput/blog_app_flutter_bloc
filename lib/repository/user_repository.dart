import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blog_api_app/constants.dart';
import 'package:blog_api_app/helpers/http_exception.dart';
import 'package:blog_api_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
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

  Future<void> logInUser(String username, String password) async {
    final http.Response response = await http.post(
      '$apiAccountUrl/login/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, dynamic>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      _token = responseData['token'];
      _userId = responseData['id'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: double.parse(responseData['expires_in']).round()),
      );
      _autoLogout();

      final _prefs = await SharedPreferences.getInstance();
      final _userData = json.encode({
        "token": _token,
        "id": _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      _prefs.setString('userData', _userData);
    } else {
      print(response.statusCode);
      final errorData = json.decode(response.body);
      print(errorData);
      throw HttpExceptionHelper(errorData['error_message']);
    }
  }

  Future<void> registerUser(
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
    } else {
      final errorData = jsonDecode(response.body);
      print(errorData);
      throw HttpExceptionHelper(errorData['error_message']);
    }
  }

  Future<bool> isFirstTime(String userId) async {
    bool exists;
    final http.Response response = await http.get(
        '$apiAccountUrl/check_if_account_exists/$userId/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);
      exists = responseData['response'];
    }
    return exists;
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

  Future<void> profileSetup(
    String firstName,
    String lastName,
    String phone,
    String dob,
    String gender,
  ) async {
    final http.Response response = await http.put(
      '$apiAccountUrl/update/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      },
      body: json.encode(<String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'dob': dob,
        'gender': gender,
        'timestamp': DateTime.now().toString(),
      }),
    );

    print(response.statusCode);
    final responseData = json.decode(response.body);
    print(responseData);
  }

  Future<User> fetchCurrentUserData() async {
    print("Fetching User Data...");

    try {
      final response = await http
          .get('$apiAccountUrl/details/$_userId/', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      });

      var _jsonData = utf8.decode(response.bodyBytes);

      final latestData = json.decode(_jsonData);

      print("Data Fetched");
      return User.fromJson(latestData);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return User.withError("Data not found / Connection issue");
    }
  }

  Future<User> fetchUserData(String userId) async {
    var followResponse;
    var followData;
    try {
      final response = await http
          .get('$apiAccountUrl/details/$userId/', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      });

      if (userId != _userId) {
        followResponse = await http.get(
          '$apiAccountUrl/is_following/$userId/',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token $_token',
          },
        );
        followData = json.decode(utf8.decode(followResponse.bodyBytes));
        print(followData);
      }

      final responseData = json.decode(utf8.decode(response.bodyBytes));

      return User.fromJson(responseData, followData: followData);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return User.withError("Data not found / Connection issue");
    }
  }

  Future<void> userFollowToggle(String userId) async {
    try {
      final response = await http.get(
        '$apiAccountUrl/follow/$userId',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $_token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        print(responseData);
      }
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return User.withError("Data not found / Connection issue");
    }
  }

  Future<void> updateUserData(
    String firstName,
    String lastName,
    String phone,
    String dob,
    String about,
    String timestamp,
  ) async {
    final response = await http.put(
      '$apiAccountUrl/update/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      },
      body: jsonEncode(<String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'dob': dob,
        'about': about,
        'timestamp': timestamp,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      print(responseData);
    } else {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      throw HttpExceptionHelper(errorData['detail'][0]);
    }
  }

  Future<void> uploadProfilePicture(File image, String timestamp) async {
    Map<String, String> headers = {
      'Authorization': 'Token $_token',
    };

    var _apiUrl = Uri.parse('$apiAccountUrl/upload_profile_picture/');

    var request = http.MultipartRequest("POST", _apiUrl);

    request.headers.addAll(headers);
    request.fields['timestamp'] = timestamp;

    var fileStream = http.ByteStream(image.openRead());
    var fileLength = await image.length();
    var multiPartFile = http.MultipartFile(
      'image',
      fileStream,
      fileLength,
      filename: image.path,
    );
    request.files.add(multiPartFile);

    var response = await request.send();

    print(response.statusCode);
    final responseString = await http.Response.fromStream(response);
    final responseData = json.decode(utf8.decode(responseString.bodyBytes));
    print(response.statusCode);
    print(responseData);
  }
}

class NetworkError extends Error {}
