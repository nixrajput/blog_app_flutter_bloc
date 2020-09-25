import 'dart:convert';
import 'dart:io';

import 'package:blog_api_app/constants.dart';
import 'package:blog_api_app/models/blog_post.dart';
import 'package:blog_api_app/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BlogRepository {
  final UserRepository _userRepository;

  BlogRepository({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  Future<BlogPost> fetchBlogPost() async {
    print("Fetching Data...");

    try {
      final response = await http.get(
        '$apiBlogUrl/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${_userRepository.token}',
        },
      );

      var _jsonData = utf8.decode(response.bodyBytes);

      final latestData = json.decode(_jsonData);

      print("Data Fetched");
      return BlogPost.fromJson(latestData);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BlogPost.withError("Data not found / Connection issue");
    }
  }

  Future<void> fetchUserBlogPost(String userId) async {
    print("Fetching Data...");

    try {
      final response = await http.get(
        '$apiBlogUrl/list/$userId',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${_userRepository.token}',
        },
      );

      var _jsonData = utf8.decode(response.bodyBytes);

      final latestData = json.decode(_jsonData);

      print("Data Fetched");
      return BlogPost.fromJson(latestData);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BlogPost.withError("Data not found / Connection issue");
    }
  }

  Future<void> postLikeToggle(String slug) async {
    try {
      final response = await http.get(
        '$apiBlogUrl/$slug/like',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${_userRepository.token}',
        },
      );

      final responseData = json.decode(utf8.decode(response.bodyBytes));
      print(responseData);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BlogPost.withError("Data not found / Connection issue");
    }
  }

  Future<void> deletePost(String slug) async {
    try {
      final response = await http
          .delete('$apiBlogUrl/$slug/delete/', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${_userRepository.token}',
      });

      final responseData = json.decode(utf8.decode(response.bodyBytes));
      print(responseData);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BlogPost.withError("Data not found / Connection issue");
    }
  }

  Future<void> createPost(
    File image,
    String title,
    String body,
    String timestamp,
  ) async {
    Map<String, String> headers = {
      'Authorization': 'Token ${_userRepository.token}',
    };

    var apiUrl = Uri.parse('$apiBlogUrl/create/');

    var request = http.MultipartRequest("POST", apiUrl);
    request.headers.addAll(headers);
    request.fields['title'] = title;
    request.fields['body'] = body;
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
    final responseString = await http.Response.fromStream(response);
    final responseData = json.decode(utf8.decode(responseString.bodyBytes));

    if (response.statusCode == 201) {
      print(responseData);
    }
  }
}

class NetworkError extends Error {}
