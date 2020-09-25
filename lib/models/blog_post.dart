class BlogPost {
  int count;
  String next;
  String previous;
  List<Results> results;
  String error;

  BlogPost({this.count, this.next, this.previous, this.results});

  BlogPost.withError(String errorMessage) {
    error = errorMessage;
  }

  BlogPost.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int id;
  String title;
  String body;
  String image;
  String slug;
  List<String> likes;
  int likeCount;
  bool isLiked;
  String author;
  String authorId;
  ProfilePicUrl profilePicUrl;
  String token;
  String timestamp;

  Results(
      {this.id,
      this.title,
      this.body,
      this.image,
      this.slug,
      this.likes,
      this.likeCount,
      this.isLiked,
      this.author,
      this.authorId,
      this.profilePicUrl,
      this.token,
      this.timestamp});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    slug = json['slug'];
    likes = json['likes'].cast<String>();
    likeCount = json['like_count'];
    isLiked = json['is_liked'];
    author = json['author'];
    authorId = json['author_id'];
    profilePicUrl = json['profile_pic_url'] != null
        ? new ProfilePicUrl.fromJson(json['profile_pic_url'])
        : null;
    token = json['token'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    data['slug'] = this.slug;
    data['likes'] = this.likes;
    data['like_count'] = this.likeCount;
    data['is_liked'] = this.isLiked;
    data['author'] = this.author;
    data['author_id'] = this.authorId;
    if (this.profilePicUrl != null) {
      data['profile_pic_url'] = this.profilePicUrl.toJson();
    }
    data['token'] = this.token;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class ProfilePicUrl {
  String image;

  ProfilePicUrl({this.image});

  ProfilePicUrl.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}
