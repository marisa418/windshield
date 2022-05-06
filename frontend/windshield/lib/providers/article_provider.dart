import 'package:flutter/material.dart';

import 'package:windshield/models/article/article.dart';

class ArticleProvider extends ChangeNotifier {
  int _page = 1;
  int get page => _page;

  Articles _articles = Articles(articles: [], pages: 1);
  Articles get articles => _articles;

  final List<bool> _areTopicsEnable = [true, true, true, true];
  List<bool> get areTopicsEnable => _areTopicsEnable;

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
}
