import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/category.dart';

class StatementCreateProvider extends ChangeNotifier {
  String _startDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  String _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  String get startDate => _startDate;
  String get endDate => _endDate;

  int _selectedPage = 0;
  int get selectedPage => _selectedPage;

  List<Category> _category = [];
  List<Category> get category => _category;

  void setStartDate(String date) {
    _startDate = date;
    print(_startDate);
    notifyListeners();
  }

  void setEndDate(String date) {
    _endDate = date;
    notifyListeners();
  }

  int getDateDiff() {
    final DateTime start = Intl.withLocale(
        'en', () => new DateFormat('yyyy-MM-dd').parse(startDate));
    final DateTime end = Intl.withLocale(
        'en', () => new DateFormat('yyyy-MM-dd').parse(endDate));
    final diff = start.difference(end).inDays * -1;
    if (diff == 0) {
      return 0;
    }
    return diff + 1;
  }

  void setSelectedPage(int value) {
    _selectedPage = value;
    notifyListeners();
  }

  void setCategories(List<Category> cat) {
    _category = cat;
    notifyListeners();
  }
}
