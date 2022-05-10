import 'package:flutter/material.dart';

import 'package:windshield/models/article/article.dart';

class ArticleProvider extends ChangeNotifier {
  Articles _articles = Articles(articles: [], pages: 1);
  Articles get articles => _articles;

  int _page = 1;
  int get page => _page;

  final List<bool> _areTopicsEnable = [true, true, true, true];
  List<bool> get areTopicsEnable => _areTopicsEnable;

  String _search = '';
  String get search => _search;

  //Sorting
  String _currSort = 'topic';
  String get currSort => _currSort;
  final List<String> _sortList = [
    'ชื่อบทความ',
    'จำนวนเข้าชม',
    'ราคา',
    'วันที่อัปโหลด',
  ];
  List<String> get sortList => _sortList;
  bool _isAscend = true;
  bool get isAscend => _isAscend;
  final List<int> _priceRange = [0, 0];
  List<int> get priceRange => _priceRange;

  int _id = 0;
  int get id => _id;

  ArticleRead _articleRead = ArticleRead(
    id: 0,
    subject: [],
    like: false,
    body: '',
    topic: '',
    img: '',
    view: 0,
    price: 0,
    uploadDate: DateTime.now(),
    author: '',
  );
  ArticleRead get articleRead => _articleRead;

  void setArticles(Articles value) {
    _articles = value;
    notifyListeners();
  }

  void setPage(int value) {
    _page = value;
    notifyListeners();
  }

  void setAreTopicsEnable(int idx, bool value) {
    _areTopicsEnable[idx] = value;
    notifyListeners();
  }

  void setSearch(String value) {
    _search = value;
  }

  void setCurrSort(String value) {
    _currSort = value;
    notifyListeners();
  }

  String returnString(String value) {
    if (value.contains('ชื่อบทความ')) return 'topic';
    if (value.contains('จำนวนเข้าชม')) return 'view';
    if (value.contains('ราคา')) return 'exclusive_price';
    return 'upload_on';
  }

  void setIsAscend(bool value) {
    _isAscend = value;
    notifyListeners();
  }

  void setPriceRange(int value, int idx) {
    _priceRange[idx] = value;
    notifyListeners();
  }

  void setId(int value) {
    _id = value;
    notifyListeners();
  }

  void setReadArticle(ArticleRead value) {
    _articleRead = value;
    notifyListeners();
  }

  // void setTopic(bool value) {
  //   _topic = value;
  //   notifyListeners();
  // }

  // void setView(bool value) {
  //   _view = value;
  //   notifyListeners();
  // }

  // void setPrice(bool value) {
  //   _price = value;
  //   notifyListeners();
  // }

  // void setDate(bool value) {
  //   _date = value;
  //   notifyListeners();
  // }
}
