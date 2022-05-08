class Articles {
  List<Article> articles;
  int pages;

  Articles({
    required this.articles,
    required this.pages,
  });

  factory Articles.fromJson(Map<String, dynamic> json, String url) => Articles(
        articles: List<Article>.from(
            json['articles'].map((x) => Article.fromJson(x, url))),
        pages: json['total pages'],
      );
}

class Article {
  int id;
  List<Subject> subject;
  bool isUnlock;
  String topic;
  String img;
  int view;
  int price;
  DateTime uploadDate;
  String author;

  Article({
    required this.id,
    required this.subject,
    required this.isUnlock,
    required this.topic,
    required this.img,
    required this.view,
    required this.price,
    required this.uploadDate,
    required this.author,
  });

  factory Article.fromJson(Map<String, dynamic> json, String url) => Article(
        id: json['id'],
        subject:
            List<Subject>.from(json['subject'].map((x) => Subject.fromJson(x))),
        isUnlock: json['isunlock'],
        topic: json['topic'],
        img: url + json['image'],
        view: json['view'],
        price: json['exclusive_price'],
        uploadDate: DateTime.parse(json['upload_on']),
        author: json['author'],
      );
}

class Subject {
  int id;
  String name;

  Subject({
    required this.id,
    required this.name,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json['id'],
        name: json['name'],
      );
}

class ArticleRead {
  int id;
  List<Subject> subject;
  bool like;
  String topic;
  String body;
  String img;
  int view;
  int price;
  DateTime uploadDate;
  String author;

  ArticleRead({
    required this.id,
    required this.subject,
    required this.like,
    required this.body,
    required this.topic,
    required this.img,
    required this.view,
    required this.price,
    required this.uploadDate,
    required this.author,
  });

  factory ArticleRead.fromJson(Map<String, dynamic> json, String url) =>
      ArticleRead(
        id: json['id'],
        subject:
            List<Subject>.from(json['subject'].map((x) => Subject.fromJson(x))),
        like: json['like'],
        topic: json['topic'],
        body: json['body'],
        img: url + json['image'],
        view: json['view'],
        price: json['exclusive_price'],
        uploadDate: DateTime.parse(json['upload_on']),
        author: json['author'],
      );
}
