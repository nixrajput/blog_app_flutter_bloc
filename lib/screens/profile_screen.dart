// import 'dart:io';
//
// import 'package:blog_api_app/providers/auth_provider.dart';
// import 'package:blog_api_app/providers/blog_provider.dart';
// import 'package:blog_api_app/providers/user_provider.dart';
// import 'package:blog_api_app/widgets/app_bar/custom_page_app_bar.dart';
// import 'package:blog_api_app/widgets/buttons/bottom_sheet_button.dart';
// import 'package:blog_api_app/widgets/card/followers_card.dart';
// import 'package:blog_api_app/widgets/choosers/custom_date_chooser.dart';
// import 'package:blog_api_app/widgets/common/custom_body_text.dart';
// import 'package:blog_api_app/widgets/image_helper/rounded_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// class ProfileScreen extends StatefulWidget {
//   static const routeName = "profile-screen";
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _formKey = GlobalKey<FormState>();
//   var _firstName;
//   var _lastName;
//   var _phone;
//   var _dob;
//   var _about;
//   File _userImageFile;
//   var _isLoading = false;
//   var _isEditing = false;
//   AutovalidateMode _autoValidateMode;
//
//
//
//   Widget actionButton(BuildContext context, dob) {
//     return _isEditing
//         ? IconButton(
//             icon: Icon(
//               Icons.save,
//               color: Theme.of(context).accentColor,
//             ),
//             onPressed: () {
//               _saveUserData(dob);
//             },
//           )
//         : IconButton(
//             icon: Icon(
//               Icons.edit,
//               color: Theme.of(context).accentColor,
//             ),
//             onPressed: () {
//               setState(() {
//                 _isEditing = !_isEditing;
//               });
//             },
//           );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final _auth = Provider.of<AuthProvider>(context, listen: false);
//     final _currentUserData =
//         Provider.of<UserDataProvider>(context, listen: true).currentUserData;
//     return Scaffold(
//       key: _scaffoldKey,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // CustomPageAppBar(
//             //   _currentUserData.first.username,
//             //   actionButton(context, _currentUserData.first.dob),
//             //   Icons.arrow_back,
//             //   _isEditing
//             //       ? () {
//             //           setState(() {
//             //             _isEditing = !_isEditing;
//             //           });
//             //         }
//             //       : () {
//             //           Navigator.pop(context);
//             //         },
//             // ),
//             if (_isLoading) SizedBox(height: 20.0),
//             if (_isLoading) CircularProgressIndicator(),
//             if (_isLoading) SizedBox(height: 20.0),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: _isEditing
//                     ? buildProfileEditScreen(
//                         context,
//                         _currentUserData,
//                       )
//                     : buildProfileScreen(
//                         context,
//                         _currentUserData,
//                         _auth,
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildProfileScreen(BuildContext context, currentUserData, auth) {
//     return Column(
//       children: [
//         SizedBox(height: 20.0),
//         _imageArea(context, currentUserData.first),
//         SizedBox(height: 20.0),
//         Text(
//           "${currentUserData.first.firstName} ${currentUserData.first.lastName}",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Theme.of(context).accentColor,
//             fontWeight: FontWeight.bold,
//             fontSize: 20.0,
//             fontFamily: "Raleway",
//           ),
//         ),
//         SizedBox(height: 10.0),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text(
//             currentUserData.first.about == null ||
//                     currentUserData.first.about == ''
//                 ? "Write something about you..."
//                 : "${currentUserData.first.about}",
//             style: TextStyle(
//               color:
//                   Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6),
//             ),
//           ),
//         ),
//         SizedBox(height: 10.0),
//         CustomBodyText(
//           icon: Icons.email_outlined,
//           value: "${currentUserData.first.email}",
//         ),
//         CustomBodyText(
//           icon: Icons.local_phone_outlined,
//           value: "${currentUserData.first.phone}",
//         ),
//         CustomBodyText(
//             icon: Icons.calendar_today_outlined,
//             value: DateFormat('dd-MMM-y').format(
//               DateTime.parse("${currentUserData.first.dob}"),
//             )),
//         FollowersCard(
//           followers: "${currentUserData.first.followers.length.toString()}",
//           following: "${currentUserData.first.following.length.toString()}",
//         ),
//         SizedBox(height: 10.0),
//         FutureBuilder(
//           // future: Provider.of<BlogProvider>(context, listen: false)
//           //     .fetchUserBlogPost(auth.userId),
//           builder: (_, _snapshot) {
//             if (_snapshot.hasError) {
//               print("${_snapshot.error}");
//             }
//             if (_snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             }
//             return Consumer<BlogProvider>(
//               builder: (_, _blogPostData, __) => _blogPostData
//                           .blogPosts.length >
//                       0
//                   ? ListView.builder(
//                       // shrinkWrap: true,
//                       // physics: ScrollPhysics(),
//                       // itemCount: _blogPostData.blogPosts.length,
//                       // itemBuilder: (_, i) => BlogPostItem(
//                       //   title: _blogPostData.blogPosts[i].title,
//                       //   body: _blogPostData.blogPosts[i].body,
//                       //   imageUrl: _blogPostData.blogPosts[i].imageUrl,
//                       //   slug: _blogPostData.blogPosts[i].slug,
//                       //   author: _blogPostData.blogPosts[i].author,
//                       //   authorId: _blogPostData.blogPosts[i].authorId,
//                       //   profilePicUrl: currentUserData.first.image,
//                       //   likeCount: _blogPostData.blogPosts[i].likes.length
//                       //       .toString(),
//                       //   isLiked: _blogPostData.blogPosts[i].isLiked,
//                       //   timestamp: TimeAgo.getTimeAgo(DateTime.parse(
//                       //       _blogPostData.blogPosts[i].timestamp)),
//                       // ),
//                       )
//                   : Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.error_outline,
//                             size: 48.0,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(height: 10.0),
//                           Text(
//                             "No post available.",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18.0,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Future<void> _selectDate() async {
//     DateTime pickedDate = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(1900),
//         lastDate: DateTime.now());
//     if (pickedDate != null) {
//       setState(() {
//         _dob = DateFormat("y-MM-dd").format(pickedDate);
//       });
//     }
//   }
//
//   void _saveUserData(dob) async {
//     final isValid = _formKey.currentState.validate();
//     FocusScope.of(context).unfocus();
//
//     if (_dob == null && dob == null) {
//       final SnackBar _snackBar =
//           SnackBar(content: Text("Birth Date can't be empty."));
//       _scaffoldKey.currentState.showSnackBar(_snackBar);
//       return;
//     } else if (_dob != null) {
//       setState(() {
//         _dob = _dob;
//       });
//     } else {
//       setState(() {
//         _dob = dob;
//       });
//     }
//
//     if (isValid) {
//       _formKey.currentState.save();
//
//       setState(() {
//         _isLoading = true;
//       });
//
//       // try {
//       //   await Provider.of<UserDataProvider>(context, listen: false)
//       //       .updateUserData(
//       //     _firstName,
//       //     _lastName,
//       //     _phone,
//       //     _dob,
//       //     _about,
//       //     DateTime.now().toString(),
//       //   )
//       //       .then((_) {
//       //     final SnackBar _snackBar =
//       //         SnackBar(content: Text("Data saved successfully."));
//       //     _scaffoldKey.currentState.showSnackBar(_snackBar);
//       //   });
//       // } catch (error) {
//       //   print(error.toString());
//       //   var errorMessage = "${error.toString()}";
//       //   final SnackBar _snackBar = SnackBar(content: Text(errorMessage));
//       //   _scaffoldKey.currentState.showSnackBar(_snackBar);
//       // }
//     }
//     setState(() {
//       _isLoading = false;
//       _isEditing = false;
//     });
//   }
//
//   Widget buildProfileEditScreen(BuildContext context, currentUserData) {
//     return Form(
//       key: _formKey,
//       autovalidateMode: _autoValidateMode,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           children: [
//             SizedBox(height: 20.0),
//             TextFormField(
//               initialValue: currentUserData.first.firstName == null
//                   ? ''
//                   : "${currentUserData.first.firstName}",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).accentColor),
//               key: ValueKey('first_name'),
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return "First Name can't be empty!";
//                 } else if (value.length < 3) {
//                   return "First Name must be at least 3 characters long!";
//                 }
//                 return null;
//               },
//               keyboardType: TextInputType.text,
//               decoration: InputDecoration(
//                 labelText: "First Name",
//                 errorMaxLines: 2,
//               ),
//               onSaved: (value) {
//                 _firstName = value.trim();
//               },
//             ),
//             SizedBox(height: 10.0),
//             TextFormField(
//               initialValue: currentUserData.first.lastName == null
//                   ? ''
//                   : "${currentUserData.first.lastName}",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).accentColor),
//               key: ValueKey('last_name'),
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return "Last Name can't be empty!";
//                 } else if (value.length < 3) {
//                   return "Last Name must be at least 3 characters long!";
//                 }
//                 return null;
//               },
//               keyboardType: TextInputType.text,
//               decoration: InputDecoration(
//                 labelText: "Last Name",
//                 errorMaxLines: 2,
//               ),
//               onSaved: (value) {
//                 _lastName = value.trim();
//               },
//             ),
//             SizedBox(height: 10.0),
//             TextFormField(
//               initialValue: currentUserData.first.phone == null
//                   ? ''
//                   : "${currentUserData.first.phone}",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).accentColor),
//               key: ValueKey('phone'),
//               validator: (value) {
//                 if (value.length < 10) {
//                   return "Phone Number is invalid!";
//                 }
//                 return null;
//               },
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 labelText: "Phone",
//                 errorMaxLines: 2,
//               ),
//               onSaved: (value) {
//                 _phone = value.trim();
//               },
//             ),
//             SizedBox(height: 10.0),
//             CustomDateChooser(
//               labelText: "Birth Date",
//               valueText: _dob == null
//                   ? (currentUserData.first.dob == null
//                       ? 'Select Date'
//                       : DateFormat('dd-MMM-y')
//                           .format(DateTime.parse(currentUserData.first.dob)))
//                   : DateFormat('dd-MMM-y').format(DateTime.parse(_dob)),
//               onPressed: _selectDate,
//             ),
//             SizedBox(height: 10.0),
//             TextFormField(
//               initialValue: currentUserData.first.about == null ||
//                       currentUserData.first.about == ''
//                   ? 'Write about you here...'
//                   : "${currentUserData.first.about}",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).accentColor),
//               key: ValueKey('about'),
//               validator: (value) {
//                 if (value.length > 150) {
//                   return "Character limit exceeded!";
//                 } else if (value.trim() == 'Write about you here...') {
//                   return "Write something about you first!";
//                 } else if (value.trim() == '') {
//                   return "Write something about you first!";
//                 }
//                 return null;
//               },
//               maxLength: 150,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 labelText: "Bio",
//                 errorMaxLines: 2,
//               ),
//               onSaved: (value) {
//                 _about = value.trim();
//               },
//             )
//             // SizedBox(height: 10.0),
//             // DropdownButtonFormField(
//             //   value: _accountType,
//             //   hint: Text("Account Type"),
//             //   items: _accountTypes
//             //       .map((title) => DropdownMenuItem(
//             //             child: Text(title.toString().toUpperCase()),
//             //             value: title,
//             //           ))
//             //       .toList(),
//             //   onChanged: (value) {
//             //     print(value);
//             //     _accountType = value;
//             //   },
//             // ),
//             // InputDatePickerFormField(
//             //   initialDate: DateTime.now(),
//             //   firstDate: DateTime(1900),
//             //   lastDate: DateTime.now(),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
//
//   // List<String> _accountTypes = ["public", "private"];
//
//
//
//
//
// }
