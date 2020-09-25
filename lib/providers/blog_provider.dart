import 'package:blog_api_app/models/blog_post.dart';
import 'package:flutter/foundation.dart';

class BlogProvider with ChangeNotifier {
  List<BlogPost> _allBlogPosts = [];
  List<BlogPost> _blogPosts = [];
  final String _token;
  final String _userId;

  BlogProvider(
    this._token,
    this._userId,
  );

  List<BlogPost> get allBlogPosts {
    return [..._allBlogPosts];
  }

  List<BlogPost> get blogPosts {
    return [..._blogPosts];
  }

// Future fetchBlogPost() async {
//   print("Fetching Data...");
//   final response = await http.get(
//     '$apiBlogUrl/',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Token $_token',
//     },
//   );
//
//   if (response.statusCode == 200) {
//     var _jsonData = utf8.decode(response.bodyBytes);
//
//     final latestData = json.decode(_jsonData);
//
//     List<BlogPost> _fetchedBlogPost = [];
//
//     for (int i = 0; i < latestData.length; i++) {
//       var post = latestData[i];
//       final authorData = await http.get(
//         '$apiAccountUrl/details/${post['author_id']}',
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization': 'Token $_token',
//         },
//       );
//       final authorDetails = json.decode(utf8.decode(authorData.bodyBytes));
//       _fetchedBlogPost.add(
//         BlogPost(
//           title: post['title'],
//           body: post['body'],
//           imageUrl: post['image'],
//           slug: post['slug'],
//           timestamp: post['timestamp'],
//           author: authorDetails['username'],
//           authorId: authorDetails['id'],
//           profilePicUrl: authorDetails['profile_picture']['image'],
//           likeCount: post['like_count'],
//           likes: post['likes'],
//           isLiked: post['is_liked'],
//         ),
//       );
//     }
//     _allBlogPosts = _fetchedBlogPost;
//     notifyListeners();
//   } else {
//     final errorData = jsonDecode(response.body);
//     throw HttpExceptionHelper(errorData['error_message']);
//   }
//   print("Data Fetched");
// }
//
// Future<void> fetchUserBlogPost(String userId) async {
//   final response = await http.get(
//     '$apiBlogUrl/list/$userId',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Token $_token',
//     },
//   );
//
//   if (response.statusCode == 200) {
//     final latestData = json.decode(utf8.decode(response.bodyBytes));
//     List<BlogPost> _fetchedBlogPost = [];
//     for (int i = 0; i < latestData.length; i++) {
//       var post = latestData[i];
//       _fetchedBlogPost.add(
//         BlogPost(
//           title: post['title'],
//           body: post['body'],
//           imageUrl: post['image'],
//           slug: post['slug'],
//           timestamp: post['timestamp'],
//           author: post['author'],
//           authorId: post['author_id'],
//           likeCount: post['like_count'],
//           likes: post['likes'],
//           isLiked: post['is_liked'],
//         ),
//       );
//     }
//     _blogPosts = _fetchedBlogPost;
//     notifyListeners();
//   } else {
//     final errorData = jsonDecode(response.body);
//     print(errorData);
//     throw HttpExceptionHelper(errorData['error_message']);
//   }
// }
//
// Future<void> postLikeToggle(String slug) async {
//   final existingProductIndex =
//       _blogPosts.indexWhere((post) => post.slug == slug);
//
//   final allExistingProductIndex =
//       _allBlogPosts.indexWhere((post) => post.slug == slug);
//
//   if (_allBlogPosts.isNotEmpty &&
//       _allBlogPosts.elementAt(allExistingProductIndex).slug == slug) {
//     if (_allBlogPosts
//         .elementAt(allExistingProductIndex)
//         .likes
//         .contains(_userId)) {
//       _allBlogPosts.elementAt(allExistingProductIndex).likes.remove(_userId);
//       _allBlogPosts.elementAt(allExistingProductIndex).isLiked = false;
//     } else {
//       _allBlogPosts.elementAt(allExistingProductIndex).likes.add(_userId);
//       _allBlogPosts.elementAt(allExistingProductIndex).isLiked = true;
//     }
//   }
//
//   if (_blogPosts.isNotEmpty &&
//       _blogPosts.elementAt(existingProductIndex).slug == slug) {
//     if (_blogPosts.elementAt(existingProductIndex).likes.contains(_userId)) {
//       _blogPosts.elementAt(existingProductIndex).likes.remove(_userId);
//       _blogPosts.elementAt(existingProductIndex).isLiked = false;
//     } else {
//       _blogPosts.elementAt(existingProductIndex).likes.add(_userId);
//       _blogPosts.elementAt(existingProductIndex).isLiked = true;
//     }
//   }
//
//   notifyListeners();
//
//   final response = await http.get(
//     '$apiBlogUrl/$slug/like',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Token $_token',
//     },
//   );
//
//   if (response.statusCode == 200) {
//     final responseData = json.decode(utf8.decode(response.bodyBytes));
//     print(responseData);
//   } else {
//     final errorData = json.decode(utf8.decode(response.bodyBytes));
//     print(errorData);
//
//     if (_allBlogPosts.isNotEmpty &&
//         _allBlogPosts.elementAt(allExistingProductIndex).slug == slug) {
//       if (_allBlogPosts
//           .elementAt(allExistingProductIndex)
//           .likes
//           .contains(_userId)) {
//         _allBlogPosts
//             .elementAt(allExistingProductIndex)
//             .likes
//             .remove(_userId);
//         _allBlogPosts.elementAt(allExistingProductIndex).isLiked = false;
//       } else {
//         _allBlogPosts.elementAt(allExistingProductIndex).likes.add(_userId);
//         _allBlogPosts.elementAt(allExistingProductIndex).isLiked = true;
//       }
//     }
//
//     if (_blogPosts.isNotEmpty &&
//         _blogPosts.elementAt(existingProductIndex).slug == slug) {
//       if (_blogPosts
//           .elementAt(existingProductIndex)
//           .likes
//           .contains(_userId)) {
//         _blogPosts.elementAt(existingProductIndex).likes.remove(_userId);
//         _blogPosts.elementAt(existingProductIndex).isLiked = false;
//       } else {
//         _blogPosts.elementAt(existingProductIndex).likes.add(_userId);
//         _blogPosts.elementAt(existingProductIndex).isLiked = true;
//       }
//     }
//
//     notifyListeners();
//
//     throw HttpExceptionHelper(errorData['response']);
//   }
// }
//
// Future<void> deletePost(String slug) async {
//   final _existingProductIndex =
//       _blogPosts.indexWhere((post) => post.slug == slug);
//
//   final _allExistingProductIndex =
//       _allBlogPosts.indexWhere((post) => post.slug == slug);
//
//   final response = await http.delete(
//     '$apiBlogUrl/$slug/delete/',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Token $_token',
//     },
//   );
//   if (_blogPosts.isNotEmpty &&
//       _blogPosts.elementAt(_existingProductIndex).slug == slug) {
//     _blogPosts.removeAt(_existingProductIndex);
//   }
//
//   if (_allBlogPosts.isNotEmpty &&
//       _allBlogPosts.elementAt(_allExistingProductIndex).slug == slug) {
//     _allBlogPosts.removeAt(_allExistingProductIndex);
//   }
//   notifyListeners();
//   if (response.statusCode >= 400) {
//     if (_blogPosts.elementAt(_existingProductIndex).slug == slug) {
//       var _existingProduct = _blogPosts[_existingProductIndex];
//       _blogPosts.insert(_existingProductIndex, _existingProduct);
//     }
//
//     if (_allBlogPosts.elementAt(_allExistingProductIndex).slug == slug) {
//       var _allExistingProduct = _allBlogPosts[_allExistingProductIndex];
//       _allBlogPosts.insert(_allExistingProductIndex, _allExistingProduct);
//     }
//     notifyListeners();
//     final errorData = json.decode(utf8.decode(response.bodyBytes));
//     print(errorData);
//     throw HttpExceptionHelper(errorData['response']);
//   }
// }
//
// Future<void> createPost(
//     File image, String title, String body, String timestamp) async {
//   Map<String, String> headers = {
//     'Authorization': 'Token $_token',
//   };
//
//   var apiUrl = Uri.parse('$apiBlogUrl/create/');
//
//   var request = http.MultipartRequest("POST", apiUrl);
//   request.headers.addAll(headers);
//   request.fields['title'] = title;
//   request.fields['body'] = body;
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
//   final responseString = await http.Response.fromStream(response);
//   final responseData = json.decode(utf8.decode(responseString.bodyBytes));
//
//   if (response.statusCode == 201) {
//     print(responseData);
//     await fetchBlogPost();
//     notifyListeners();
//   } else {
//     throw HttpExceptionHelper(responseData['detail']);
//   }
// }
}
