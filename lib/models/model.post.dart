// ignore_for_file: unnecessary_getters_setters

class Post {
  String? _postId;
  String? _email;
  String? _caption;
  String? _imgUri;
  int? _numOfLikes;
  int? _numOfDislikes;
  String? _category;
  String? _ts;
  List<Liker>? _liker;
  List<Disliker>? _disliker;
  List<Commenter>? _commenter;

  Post(
      {String? postId,
      String? email,
      String? caption,
      String? imgUri,
      int? numOfLikes,
      int? numOfDislikes,
      String? category,
      String? ts,
      List<Liker>? liker,
      List<Disliker>? disliker,
      List<Commenter>? commenter}) {
    if (postId != null) {
      _postId = postId;
    }
    if (email != null) {
      _email = email;
    }
    if (caption != null) {
      _caption = caption;
    }
    if (imgUri != null) {
      _imgUri = imgUri;
    }
    if (numOfLikes != null) {
      _numOfLikes = numOfLikes;
    }
    if (numOfDislikes != null) {
      _numOfDislikes = numOfDislikes;
    }
    if (category != null) {
      _category = category;
    }
    if (ts != null) {
      _ts = ts;
    }
    if (liker != null) {
      _liker = liker;
    }
    if (disliker != null) {
      _disliker = disliker;
    }
    if (commenter != null) {
      _commenter = commenter;
    }
  }

  String? get postId => _postId;
  set postId(String? postId) => _postId = postId;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get caption => _caption;
  set caption(String? caption) => _caption = caption;
  String? get imgUri => _imgUri;
  set imgUri(String? imgUri) => _imgUri = imgUri;
  int? get numOfLikes => _numOfLikes;
  set numOfLikes(int? numOfLikes) => _numOfLikes = numOfLikes;
  int? get numOfDislikes => _numOfDislikes;
  set numOfDislikes(int? numOfDislikes) => _numOfDislikes = numOfDislikes;
  String? get category => _category;
  set category(String? category) => _category = category;
  String? get ts => _ts;
  set ts(String? ts) => _ts = ts;
  List<Liker>? get liker => _liker;
  set liker(List<Liker>? liker) => _liker = liker;
  List<Disliker>? get disliker => _disliker;
  set disliker(List<Disliker>? disliker) => _disliker = disliker;
  List<Commenter>? get commenter => _commenter;
  set commenter(List<Commenter>? commenter) => _commenter = commenter;

  Post.fromJson(Map<String, dynamic> json) {
    _postId = json['post_id'];
    _email = json['email'];
    _caption = json['caption'];
    _imgUri = json['img_uri'];
    _numOfLikes = json['num_of_likes'];
    _numOfDislikes = json['num_of_dislikes'];
    _category = json['category'];
    _ts = json['ts'];
    if (json['liker'] != null) {
      _liker = <Liker>[];
      json['liker'].forEach((v) {
        _liker!.add(Liker.fromJson(v));
      });
    }
    if (json['disliker'] != null) {
      _disliker = <Disliker>[];
      json['disliker'].forEach((v) {
        _disliker!.add(Disliker.fromJson(v));
      });
    }
    if (json['commenter'] != null) {
      _commenter = <Commenter>[];
      json['commenter'].forEach((v) {
        _commenter!.add(Commenter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = _postId;
    data['email'] = _email;
    data['caption'] = _caption;
    data['img_uri'] = _imgUri;
    data['num_of_likes'] = _numOfLikes;
    data['num_of_dislikes'] = _numOfDislikes;
    data['category'] = _category;
    data['ts'] = _ts;
    if (_liker != null) {
      data['liker'] = _liker!.map((v) => v.toJson()).toList();
    }
    if (_disliker != null) {
      data['disliker'] = _disliker!.map((v) => v.toJson()).toList();
    }
    if (_commenter != null) {
      data['commenter'] = _commenter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Liker {
  String? _email;

  Liker({String? email}) {
    if (email != null) {
      _email = email;
    }
  }

  String? get email => _email;
  set email(String? email) => _email = email;

  Liker.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _email;
    return data;
  }
}

class Disliker {
  String? _email;

  Disliker({String? email}) {
    if (email != null) {
      _email = email;
    }
  }

  String? get email => _email;
  set email(String? email) => _email = email;

  Disliker.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _email;
    return data;
  }
}

class Commenter {
  String? _email;
  String? _text;
  String? _ts;

  Commenter({String? email, String? text, String? ts}) {
    if (email != null) {
      _email = email;
    }
    if (text != null) {
      _text = text;
    }
    if (ts != null) {
      _ts = ts;
    }
  }

  String? get email => _email;
  set email(String? email) => _email = email;
  String? get text => _text;
  set text(String? text) => _text = text;
  String? get ts => _ts;
  set ts(String? ts) => _ts = ts;

  Commenter.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
    _text = json['text'];
    _ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _email;
    data['text'] = _text;
    data['ts'] = _ts;
    return data;
  }
}