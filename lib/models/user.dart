class User {
  String id;
  String firstName;
  String lastName;
  String phone;
  String username;
  String email;
  String about;
  String dob;
  String gender;
  List<String> followers;
  List<String> following;
  bool isFollowing;
  ProfilePicture profilePicture;
  String accountType;
  String error;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.username,
    this.email,
    this.about,
    this.dob,
    this.gender,
    this.followers,
    this.following,
    this.isFollowing,
    this.profilePicture,
    this.accountType,
  });

  User.withError(String errorMessage) {
    error = errorMessage;
  }

  User.fromJson(Map<String, dynamic> json, {followData}) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    username = json['username'];
    email = json['email'];
    about = json['about'];
    dob = json['dob'];
    gender = json['gender'];
    followers = json['followers'].cast<String>();
    following = json['following'].cast<String>();
    isFollowing = followData != null ? followData['is_following'] : false;
    profilePicture = json['profile_picture'] != null
        ? new ProfilePicture.fromJson(json['profile_picture'])
        : null;
    accountType = json['account_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['username'] = this.username;
    data['email'] = this.email;
    data['about'] = this.about;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['followers'] = this.followers;
    data['following'] = this.following;
    data['isFollowing'] = this.isFollowing;
    if (this.profilePicture != null) {
      data['profile_picture'] = this.profilePicture.toJson();
    }
    data['account_type'] = this.accountType;
    return data;
  }
}

class ProfilePicture {
  String image;

  ProfilePicture({this.image});

  ProfilePicture.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}
