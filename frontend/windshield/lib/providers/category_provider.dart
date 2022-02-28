import 'package:flutter/material.dart';

import 'package:windshield/models/category.dart';
import 'package:windshield/models/budget.dart';

class CategoryProvider extends ChangeNotifier {
  int _isIncomePage = 0;
  int get isIncomePage => _isIncomePage;

  List<Category> _categoryList = [];
  List<Category> get categoryList => _categoryList;

  //1
  final List<Category> _incomeWorking = [];
  List<Category> get incomeWorking => _incomeWorking;
  //2
  final List<Category> _incomeAsset = [];
  List<Category> get incomeAsset => _incomeAsset;
  //3
  final List<Category> _incomeOther = [];
  List<Category> get incomeOther => _incomeOther;
  //4
  final List<Category> _expenseInconsistency = [];
  List<Category> get expenseInconsistency => _expenseInconsistency;
  //5
  final List<Category> _expenseConsistency = [];
  List<Category> get expenseConsistency => _expenseConsistency;
  //6
  final List<Category> _savingAndInvest = [];
  List<Category> get savingAndInvest => _savingAndInvest;
  //7
  final List<Category> _assetLiquid = [];
  List<Category> get assetLiquid => _assetLiquid;
  //8
  final List<Category> _assetInvestment = [];
  List<Category> get assetInvestment => _assetInvestment;
  //9
  final List<Category> _assetPrivate = [];
  List<Category> get assetPrivate => _assetPrivate;
  //10
  final List<Category> _debtShort = [];
  List<Category> get debtShort => _debtShort;
  //11
  final List<Category> _debtLong = [];
  List<Category> get debtLong => _debtLong;
  //12
  final List<Category> _financialGoal = [];
  List<Category> get financialGoal => _financialGoal;

  //1
  final List<Category> _incomeWorkingTab = [];
  List<Category> get incomeWorkingTab => _incomeWorkingTab;
  int _incomeWorkingTotal = 0;
  int get incomeWorkingTotal => _incomeWorkingTotal;
  //2
  final List<Category> _incomeAssetTab = [];
  List<Category> get incomeAssetTab => _incomeAssetTab;
  int _incomeAssetTotal = 0;
  int get incomeAssetTotal => _incomeAssetTotal;
  //3
  final List<Category> _incomeOtherTab = [];
  List<Category> get incomeOtherTab => _incomeOtherTab;
  int _incomeOtherTotal = 0;
  int get incomeOtherTotal => _incomeOtherTotal;
  //4 & 10
  final List<Category> _expenseInconsistencyTab = [];
  List<Category> get expenseInconsistencyTab => _expenseInconsistencyTab;
  int _expenseInconsistencyTotal = 0;
  int get expenseInconsistencyTotal => _expenseInconsistencyTotal;
  //5 & 11
  final List<Category> _expenseConsistencyTab = [];
  List<Category> get expenseConsistencyTab => _expenseConsistencyTab;
  int _expenseConsistencyTotal = 0;
  int get expenseConsistencyTotal => _expenseConsistencyTotal;
  //6 & 12
  final List<Category> _savingAndInvestTab = [];
  List<Category> get savingAndInvestTab => _savingAndInvestTab;
  int _savingAndInvestTotal = 0;
  int get savingAndInvestTotal => _savingAndInvestTotal;

  int _incomeTotal = 0;
  int get incomeTotal => _incomeTotal;
  int _expenseTotal = 0;
  int get expenseTotal => _expenseTotal;

  final List<Budget> _budgetList = [];
  List<Budget> get budgetList => _budgetList;

  int _budgetPerPeriod = 0;
  int get budgetPerPeriod => _budgetPerPeriod;

  void setIsIncomePage(int value) {
    _isIncomePage = value;
    notifyListeners();
  }

  void setCategoryList(List<Category> value) {
    _categoryList = value;
  }

  void setCategoryTypes() {
    for (var cat in _categoryList) {
      if (cat.ftype == '1') {
        _incomeWorking.add(cat);
      } else if (cat.ftype == '2') {
        _incomeAsset.add(cat);
      } else if (cat.ftype == '3') {
        _incomeOther.add(cat);
      } else if (cat.ftype == '4') {
        _expenseInconsistency.add(cat);
      } else if (cat.ftype == '5') {
        _expenseConsistency.add(cat);
      } else if (cat.ftype == '6') {
        _savingAndInvest.add(cat);
      } else if (cat.ftype == '7') {
        _assetLiquid.add(cat);
      } else if (cat.ftype == '8') {
        _assetInvestment.add(cat);
      } else if (cat.ftype == '9') {
        _assetPrivate.add(cat);
      } else if (cat.ftype == '10') {
        _debtShort.add(cat);
      } else if (cat.ftype == '11') {
        _debtLong.add(cat);
      } else if (cat.ftype == '12') {
        _financialGoal.add(cat);
      }
    }
  }

  void setCategoryTypeTabs() {
    for (var cat in _categoryList) {
      if (cat.ftype == '1') {
        _incomeWorkingTab.add(cat);
      } else if (cat.ftype == '2') {
        _incomeAssetTab.add(cat);
      } else if (cat.ftype == '3') {
        _incomeOtherTab.add(cat);
      } else if (cat.ftype == '4' || cat.ftype == '10') {
        _expenseInconsistencyTab.add(cat);
      } else if (cat.ftype == '5' || cat.ftype == '11') {
        _expenseConsistencyTab.add(cat);
      } else if (cat.ftype == '6' || cat.ftype == '12') {
        _savingAndInvestTab.add(cat);
      }
    }
  }

  void addBudget(Category cat, int catIndex, int budgetPerPeriod, String freq,
      int numOfDays) {
    int total = 0;
    if (freq == 'DLY') {
      total = budgetPerPeriod * numOfDays;
    } else if (freq == 'WLY') {
      total = budgetPerPeriod * numOfDays;
    } else if (freq == 'MLY') {
      total = budgetPerPeriod * numOfDays;
    }
    Budget budget = Budget(
      catId: cat.id,
      fplan: '',
      balance: 0,
      totalBudget: total,
      budgetPerPeriod: budgetPerPeriod,
      frequency: 'MLY',
      dueDate: '2022-03-31',
    );
    _budgetList.add(budget);
    _categoryList[catIndex].active = true;
    _setTotalOnType(_categoryList[catIndex], total);
    _categoryList[catIndex].total = total;
    notifyListeners();
  }

  void removeBudget(Category cat, int catIndex) {
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
