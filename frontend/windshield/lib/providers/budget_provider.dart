import 'package:flutter/material.dart';

import 'package:windshield/models/statement/category.dart';
import 'package:windshield/models/statement/budget.dart';

class BudgetProvider extends ChangeNotifier {
  List<StmntCategory> _catList = [];
  List<StmntCategory> get catList => _catList;

  //1
  final List<StmntCategory> _incWorkingTab = [];
  List<StmntCategory> get incWorkingTab => _incWorkingTab;
  double _incWorkingTotal = 0;
  double get incomeWorkingTotal => _incWorkingTotal;
  //2
  final List<StmntCategory> _incAssetTab = [];
  List<StmntCategory> get incAssetTab => _incAssetTab;
  double _incAssetTotal = 0;
  double get incAssetTotal => _incAssetTotal;
  //3
  final List<StmntCategory> _incOtherTab = [];
  List<StmntCategory> get incOtherTab => _incOtherTab;
  double _incOtherTotal = 0;
  double get incOtherTotal => _incOtherTotal;
  //4 & 10
  final List<StmntCategory> _expInconsistencyTab = [];
  List<StmntCategory> get expInconsistencyTab => _expInconsistencyTab;
  double _expInconsistencyTotal = 0;
  double get expInconsistencyTotal => _expInconsistencyTotal;
  //5 & 11
  final List<StmntCategory> _expConsistencyTab = [];
  List<StmntCategory> get expConsistencyTab => _expConsistencyTab;
  double _expConsistencyTotal = 0;
  double get expConsistencyTotal => _expConsistencyTotal;
  //6 & 12
  final List<StmntCategory> _savingInvestTab = [];
  List<StmntCategory> get savingInvestTab => _savingInvestTab;
  double _savingInvestTotal = 0;
  double get savingInvestTotal => _savingInvestTotal;

  double _incexpIdx = 0;
  double get incexpIdx => _incexpIdx;
  double _incTotal = 0;
  double get incTotal => _incTotal;
  double _expTotal = 0;
  double get expTotal => _expTotal;

  final List<StmntBudget> _budList = [];
  List<StmntBudget> get budList => _budList;
  double _budPerPeriod = 0;
  double get budPerPeriod => _budPerPeriod;
  String _budType = 'MLY';
  String get budType => _budType;

  void setCatList(List<StmntCategory> value) {
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
    StmntCategory cat,
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
    StmntBudget budget = StmntBudget(
      id: '',
      catId: cat.id,
      balance: 0,
      total: total,
      budPerPeriod: _budPerPeriod,
      freq: _budType,
      fplan: '',
    );
    _budList.add(budget);
    _setTotalOnType(cat, true);
    notifyListeners();
  }

  void removeBudget(StmntCategory cat) {
    _setTotalOnType(cat, false);
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

  void setBudgetPerPeriod(double value) {
    _budPerPeriod = value;
    notifyListeners();
  }

  void setBudgetType(String value) {
    _budType = value;
    notifyListeners();
  }

  void _setTotalOnType(StmntCategory cat, bool isAdd) {
    if (cat.ftype == '1' || cat.ftype == '2' || cat.ftype == '3') {
      if (cat.ftype == '1') {
        if (!isAdd) {
          _incWorkingTotal -= cat.total;
          _incTotal -= cat.total;
        } else {
          _incWorkingTotal += _budPerPeriod;
          _incTotal += _budPerPeriod;
        }
      } else if (cat.ftype == '2') {
        if (!isAdd) {
          _incAssetTotal -= cat.total;
          _incTotal -= cat.total;
        } else {
          _incAssetTotal += _budPerPeriod;
          _incTotal += _budPerPeriod;
        }
      } else {
        if (!isAdd) {
          _incOtherTotal -= cat.total;
          _incTotal -= cat.total;
        } else {
          _incOtherTotal += _budPerPeriod;
          _incTotal += _budPerPeriod;
        }
      }
    } else {
      if (cat.ftype == '4' || cat.ftype == '10') {
        if (!isAdd) {
          _expInconsistencyTotal -= cat.total;
          _expTotal -= cat.total;
        } else {
          _expInconsistencyTotal += _budPerPeriod;
          _expTotal += _budPerPeriod;
        }
      } else if (cat.ftype == '5' || cat.ftype == '11') {
        if (!isAdd) {
          _expConsistencyTotal -= cat.total;
          _expTotal -= cat.total;
        } else {
          _expConsistencyTotal += _budPerPeriod;
          _expTotal += _budPerPeriod;
        }
      } else {
        if (!isAdd) {
          _savingInvestTotal -= cat.total;
          _expTotal -= cat.total;
        } else {
          _savingInvestTotal += _budPerPeriod;
          _expTotal += _budPerPeriod;
        }
      }
    }
  }

  // int findCatIndex(StmntCategory cat) {
  //   return _categoryList.indexWhere((e) => e.id == cat.id);
  // }

  // bool isActive(StmntCategory cat, int catIndex) {
  //   return _categoryList[catIndex].active;
  // }
}
