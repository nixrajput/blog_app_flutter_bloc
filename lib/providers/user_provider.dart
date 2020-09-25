import 'package:blog_api_app/models/user.dart';
import 'package:flutter/foundation.dart';

class UserDataProvider with ChangeNotifier {
  List<User> _currentUserData = [];
  List<User> _userData = [];
  final String _token;
  final String _currentUserId;

  UserDataProvider(
    this._token,
    this._currentUserId,
  );

  List<User> get currentUserData {
    return [..._currentUserData];
  }

  List<User> get userData {
    return [..._userData];
  }

// Future<void> fetchCurrentUserData() async {
//   final response = await http.get(
//     '$apiAccountUrl/details/$_currentUserId/',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Token $_token',
//     },
//   );
//
//   final responseData = json.decode(utf8.decode(response.bodyBytes));
//
//   if (response.statusCode == 200) {
//     List<User> _fetchUserData = [];
//     _fetchUserData.add(
//       User(
//         id: responseData['id'],
//         firstName: responseData['first_name'],
//         lastName: responseData['last_name'],
//         email: responseData['email'],
//         username: responseData['username'],
//         dob: responseData['dob'],
//         phone: responseData['phone'],
//         image: responseData['profile_picture']['image'],
//         followers: responseData['followers'],
//         following: responseData['following'],
//         accountType: responseData['account_type'],
//         about: responseData['about'],
//       ),
//     );
//     _currentUserData = _fetchUserData;
//   } else {
//     throw HttpExceptionHelper(responseData['detail']);
//   }
//   notifyListeners();
// }
//
// Future<void> fetchUserData(String userId) async {
//   final response = await http.get(
//     '$apiAccountUrl/details/$userId/',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Token $_token',
//     },
//   );
//
//   var followResponse;
//   var followData;
//
//   if (userId != _currentUserId) {
//     followResponse = await http.get(
//       '$apiAccountUrl/is_following/$userId/',
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Token $_token',
//       },
//     );
//     followData = json.decode(utf8.decode(followResponse.bodyBytes));
//     print(followData);
//   }
//
//   final responseData = json.decode(utf8.decode(response.bodyBytes));
//
//   if (response.statusCode == 200) {
//     List<User> _fetchUserData = [];
//     _fetchUserData.add(
//       User(
//         id: responseData['id'],
//         firstName: responseData['first_name'],
//         lastName: responseData['last_name'],
//         email: responseData['email'],
//         username: responseData['username'],
//         dob: responseData['dob'],
//         phone: responseData['phone'],
//         accountType: responseData['account_type'],
//         about: responseData['about'],
//         image: responseData['profile_picture']['image'],
//         followers: responseData['followers'],
//         following: responseData['following'],
//         isFollowing: followData != null ? followData['is_following'] : false,
//       ),
//     );
//     _userData = _fetchUserData;
//   } else {
//     throw HttpExceptionHelper(responseData['detail']);
//   }
//   notifyListeners();
// }
//
// Future<Map<String, dynamic>> userFollowToggle(String userId) async {
//   final response = await http.get(
//     '$apiAccountUrl/follow/$userId',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Token $_token',
//     },
//   );
//
//   if (response.statusCode == 200) {
//     final responseData = json.decode(utf8.decode(response.bodyBytes));
//     print(responseData);
//     if (_currentUserData.first.following.contains(userId)) {
//       _currentUserData.first.following.remove(userId);
//       _userData.first.followers.remove(_currentUserId);
//       _userData.first.isFollowing = false;
//     } else {
//       _currentUserData.first.following.add(userId);
//       _userData.first.followers.add(_currentUserId);
//       _userData.first.isFollowing = true;
//     }
//     notifyListeners();
//     return responseData;
//   } else {
//     final errorData = json.decode(utf8.decode(response.bodyBytes));
//     print(errorData);
//     throw HttpExceptionHelper(errorData['response']);
//   }
// }
//
// Future<void> uploadProfilePicture(File image, String timestamp) async {
//   Map<String, String> headers = {
//     'Authorization': 'Token $_token',
//   };
//
//   var _apiUrl = Uri.parse('$apiAccountUrl/upload_profile_picture/');
//
//   var request = http.MultipartRequest("POST", _apiUrl);
//
//   request.headers.addAll(headers);
//   request.fields['timestamp'] = timestamp;
//
//   var fileStream = http.ByteStream(image.openRead());
//   var fileLength = await image.length();
//   var multiPartFile = http.MultipartFile(
//     'image',
//     fileStream,
//     fileLength,
//     filename: image.path,
//   );
//   request.files.add(multiPartFile);
//
//   var response = await request.send();
//
//   print(response.statusCode);
//   final responseString = await http.Response.fromStream(response);
//   final responseData = json.decode(utf8.decode(responseString.bodyBytes));
//   print(response.statusCode);
//   print(responseData);
//   fetchCurrentUserData();
//   notifyListeners();
// }
//
// Future<void> updateUserData(
//   String firstName,
//   String lastName,
//   String phone,
//   String dob,
//   String about,
//   String timestamp,
// ) async {
//   final response = await http.put(
//     '$apiAccountUrl/update/',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Token $_token',
//     },
//     body: jsonEncode(<String, dynamic>{
//       'first_name': firstName,
//       'last_name': lastName,
//       'phone': phone,
//       'dob': dob,
//       'about': about,
//       'timestamp': timestamp,
//     }),
//   );
//
//   if (response.statusCode == 200) {
//     final responseData = json.decode(utf8.decode(response.bodyBytes));
//     print(responseData);
//     fetchCurrentUserData();
//     notifyListeners();
//   } else {
//     final errorData = json.decode(utf8.decode(response.bodyBytes));
//     throw HttpExceptionHelper(errorData['detail'][0]);
//   }
// }
}
