import 'package:flutter/material.dart';

import 'package:windshield/models/statement/category.dart';
import 'package:windshield/models/statement/budget.dart';

class BudgetEditProvider extends ChangeNotifier {
  List<StmntCategory> _catList = [];
  List<StmntCategory> get catList => _catList;

  //1
  final List<StmntCategory> _incWorkingTab = [];
  List<StmntCategory> get incWorkingTab => _incWorkingTab;
  double _incWorkingTotal = 0;
  double get incWorkingTotal => _incWorkingTotal;
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
  final List<StmntCategory> _expInconsistTab = [];
  List<StmntCategory> get expInconsistTab => _expInconsistTab;
  double _expInconsistTotal = 0;
  double get expInconsistTotal => _expInconsistTotal;
  //5 & 11
  final List<StmntCategory> _expConsistTab = [];
  List<StmntCategory> get expConsistTab => _expConsistTab;
  double _expConsistTotal = 0;
  double get expConsistTotal => _expConsistTotal;
  //6 & 12
  final List<StmntCategory> _savingInvestTab = [];
  List<StmntCategory> get savingInvestTab => _savingInvestTab;
  double _savingInvestTotal = 0;
  double get savingInvestTotal => _savingInvestTotal;

  int _incExpIdx = 0;
  int get incExpIdx => _incExpIdx;
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

  void setIncExpIdx(int value) {
    _incExpIdx = value;
    notifyListeners();
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
        _expInconsistTab.add(cat);
      } else if (cat.ftype == '5' || cat.ftype == '11') {
        _expConsistTab.add(cat);
      } else if (cat.ftype == '6' || cat.ftype == '12') {
        _savingInvestTab.add(cat);
      }
    }
    notifyListeners();
  }

  void setInitBudgets(List<StmntBudget> buds) {
    for (var bud in buds) {
      bud.catId = bud.cat.id;
      _budList.add(bud);
      final cat = _catList.firstWhere((e) => e.id == bud.cat.id);
      cat.active = true;
      cat.total = bud.total;
      _setTotalOnType(cat, true);
    }
    notifyListeners();
  }

  void addBudget(
    StmntCategory cat,
    int numOfDays,
    String fplanId,
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
      cat: StmntCategory(id: '', name: '', usedCount: 0, ftype: '', icon: ''),
      total: total,
      budPerPeriod: _budPerPeriod,
      freq: _budType,
      fplan: fplanId,
      catId: cat.id,
    );
    _budList.add(budget);
    cat.active = true;
    cat.total = total;
    _setTotalOnType(cat, true);
    notifyListeners();
  }

  void removeBudget(StmntCategory cat) {
    _budList.removeWhere((e) => e.catId == cat.id);
    _setTotalOnType(cat, false);
    cat.active = false;
    cat.total = 0;
    notifyListeners();
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
          _incWorkingTotal += cat.total;
          _incTotal += cat.total;
        }
      } else if (cat.ftype == '2') {
        if (!isAdd) {
          _incAssetTotal -= cat.total;
          _incTotal -= cat.total;
        } else {
          _incAssetTotal += cat.total;
          _incTotal += cat.total;
        }
      } else {
        if (!isAdd) {
          _incOtherTotal -= cat.total;
          _incTotal -= cat.total;
        } else {
          _incOtherTotal += cat.total;
          _incTotal += cat.total;
        }
      }
    } else {
      if (cat.ftype == '4' || cat.ftype == '10') {
        if (!isAdd) {
          _expInconsistTotal -= cat.total;
          _expTotal -= cat.total;
        } else {
          _expInconsistTotal += cat.total;
          _expTotal += cat.total;
        }
      } else if (cat.ftype == '5' || cat.ftype == '11') {
        if (!isAdd) {
          _expConsistTotal -= cat.total;
          _expTotal -= cat.total;
        } else {
          _expConsistTotal += cat.total;
          _expTotal += cat.total;
        }
      } else {
        if (!isAdd) {
          _savingInvestTotal -= cat.total;
          _expTotal -= cat.total;
        } else {
          _savingInvestTotal += cat.total;
          _expTotal += cat.total;
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
