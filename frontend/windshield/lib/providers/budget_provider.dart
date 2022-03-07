import 'package:flutter/material.dart';

import 'package:windshield/models/category.dart';
import 'package:windshield/models/budget.dart';

class BudgetProvider extends ChangeNotifier {
  List<Category> _catList = [];
  List<Category> get catList => _catList;

  //1
  final List<Category> _incWorkingTab = [];
  List<Category> get incWorkingTab => _incWorkingTab;
  double _incWorkingTotal = 0;
  double get incomeWorkingTotal => _incWorkingTotal;
  //2
  final List<Category> _incAssetTab = [];
  List<Category> get incAssetTab => _incAssetTab;
  double _incAssetTotal = 0;
  double get incAssetTotal => _incAssetTotal;
  //3
  final List<Category> _incOtherTab = [];
  List<Category> get incOtherTab => _incOtherTab;
  double _incOtherTotal = 0;
  double get incOtherTotal => _incOtherTotal;
  //4 & 10
  final List<Category> _expInconsistencyTab = [];
  List<Category> get expInconsistencyTab => _expInconsistencyTab;
  double _expInconsistencyTotal = 0;
  double get expInconsistencyTotal => _expInconsistencyTotal;
  //5 & 11
  final List<Category> _expConsistencyTab = [];
  List<Category> get expConsistencyTab => _expConsistencyTab;
  double _expConsistencyTotal = 0;
  double get expConsistencyTotal => _expConsistencyTotal;
  //6 & 12
  final List<Category> _savingInvestTab = [];
  List<Category> get savingInvestTab => _savingInvestTab;
  double _savingInvestTotal = 0;
  double get savingInvestTotal => _savingInvestTotal;

  double _incexpIdx = 0;
  double get incexpIdx => _incexpIdx;
  double _incTotal = 0;
  double get incTotal => _incTotal;
  double _expTotal = 0;
  double get expTotal => _expTotal;

  final List<Budget> _budList = [];
  List<Budget> get budList => _budList;
  double _budPerPeriod = 0;
  double get budPerPeriod => _budPerPeriod;
  String _budType = 'MLY';
  String get budType => _budType;

  void setCatList(List<Category> value) {
    _catList = value;
    // notifyListeners();
  }

  void setCategoryTypeTabs() {
    for (var cat in _catList) {
      if (cat.ftype == '1') {
        _incWorkingTab.add(cat);
      } else if (cat.ftype == '2') {
        _incAssetTab.add(cat);
      } else if (cat.ftype == '3') {
        _incOtherTab.add(cat);
      } else if (cat.ftype == '4' || cat.ftype == '10') {
        _expInconsistencyTab.add(cat);
      } else if (cat.ftype == '5' || cat.ftype == '11') {
        _expConsistencyTab.add(cat);
      } else if (cat.ftype == '6' || cat.ftype == '12') {
        _savingInvestTab.add(cat);
      }
    }
  }

  void addBudget(
    Category cat,
    int numOfDays,
  ) {
    double total = 0;
    if (_budType == 'DLY') {
      total = _budPerPeriod * numOfDays;
    } else if (_budType == 'WLY') {
      total = _budPerPeriod * (numOfDays / 7).ceil();
    } else if (_budType == 'MLY') {
      total = _budPerPeriod;
    }
    Budget budget = Budget(
      id: '',
      catId: cat.id,
      balance: 0,
      total: total,
      budPerPeriod: _budPerPeriod,
      freq: _budType,
      fplan: '',
    );
    _budList.add(budget);
    final catIdx = _catList.indexWhere((e) => e.id == cat.id);
    _catList[catIdx].active = true;
    _setTotalOnType(_categoryList[catIndex], total);
    _categoryList[catIndex].total = total;
    notifyListeners();
  }

  void removeBudget(Category cat) {
    _budgetList.removeWhere((e) => e.catId == cat.id);
    _categoryList[catIndex].active = false;
    _setTotalOnType(_categoryList[catIndex], -1);
    _categoryList[catIndex].total = 0;
    notifyListeners();
  }

  Color getColorByFtype(String value) {
    if (value == '1') return Colors.amber;
    if (value == '2') return Colors.lightBlue;
    if (value == '3') return Colors.deepOrange;
    if (value == '4') return Colors.deepPurple;
    if (value == '5') return Colors.green;
    if (value == '6') return Colors.pink;
    if (value == '7') return Colors.yellow;
    if (value == '8') return Colors.teal;
    if (value == '9') return Colors.blueGrey;
    if (value == '10') return Colors.red;
    if (value == '11') return Colors.purple;
    if (value == '12') return Colors.blue;
    return Colors.black;
  }

  void setBudgetPerPeriod(int value) {
    _budgetPerPeriod = value;
    notifyListeners();
  }

  void setBudgetType(String value) {
    _budgetType = value;
    notifyListeners();
  }

  void _setTotalOnType(Category cat, int total) {
    if (cat.ftype == '1' || cat.ftype == '2' || cat.ftype == '3') {
      if (cat.ftype == '1') {
        if (total == -1) {
          _incomeWorkingTotal -= cat.total;
          _incomeTotal -= cat.total;
        } else {
          _incomeWorkingTotal += total;
          _incomeTotal += total;
        }
      } else if (cat.ftype == '2') {
        if (total == -1) {
          _incomeAssetTotal -= cat.total;
          _incomeTotal -= cat.total;
        } else {
          _incomeAssetTotal += total;
          _incomeTotal += total;
        }
      } else {
        if (total == -1) {
          _incomeOtherTotal -= cat.total;
          _incomeTotal -= cat.total;
        } else {
          _incomeOtherTotal += total;
          _incomeTotal += total;
        }
      }
    } else {
      if (cat.ftype == '4' || cat.ftype == '10') {
        if (total == -1) {
          _expenseInconsistencyTotal -= cat.total;
          _expenseTotal -= cat.total;
        } else {
          _expenseInconsistencyTotal += total;
          _expenseTotal += total;
        }
      } else if (cat.ftype == '5' || cat.ftype == '11') {
        if (total == -1) {
          _expenseConsistencyTotal -= cat.total;
          _expenseTotal -= cat.total;
        } else {
          _expenseConsistencyTotal += total;
          _expenseTotal += total;
        }
      } else {
        if (total == -1) {
          _savingAndInvestTotal -= cat.total;
          _expenseTotal -= cat.total;
        } else {
          _savingAndInvestTotal += total;
          _expenseTotal += total;
        }
      }
    }
  }

  int findCatIndex(Category cat) {
    return _categoryList.indexWhere((e) => e.id == cat.id);
  }

  bool isActive(Category cat, int catIndex) {
    return _categoryList[catIndex].active;
  }
}
