import 'package:flutter/material.dart';

import 'package:windshield/models/category.dart';
import 'package:windshield/models/budget.dart';

class CategoryProvider extends ChangeNotifier {
  int _isIncomePage = 0;
  int get isIncomePage => _isIncomePage;

  List<Category> _categoryList = [];
  List<Category> get categoryList => _categoryList;

  //1
  List<Category> _incomeWorking = [];
  List<Category> get incomeWorking => _incomeWorking;
  //2
  List<Category> _incomeAsset = [];
  List<Category> get incomeAsset => _incomeAsset;
  //3
  List<Category> _incomeOther = [];
  List<Category> get incomeOther => _incomeOther;
  //4
  List<Category> _expenseInconsistency = [];
  List<Category> get expenseInconsistency => _expenseInconsistency;
  //5
  List<Category> _expenseConsistency = [];
  List<Category> get expenseConsistency => _expenseConsistency;
  //6
  List<Category> _savingAndInvest = [];
  List<Category> get savingAndInvest => _savingAndInvest;
  //7
  List<Category> _assetLiquid = [];
  List<Category> get assetLiquid => _assetLiquid;
  //8
  List<Category> _assetInvestment = [];
  List<Category> get assetInvestment => _assetInvestment;
  //9
  List<Category> _assetPrivate = [];
  List<Category> get assetPrivate => _assetPrivate;
  //10
  List<Category> _debtShort = [];
  List<Category> get debtShort => _debtShort;
  //11
  List<Category> _debtLong = [];
  List<Category> get debtLong => _debtLong;
  //12
  List<Category> _financialGoal = [];
  List<Category> get financialGoal => _financialGoal;

  //1
  List<Category> _incomeWorkingTab = [];
  List<Category> get incomeWorkingTab => _incomeWorkingTab;
  //2
  List<Category> _incomeAssetTab = [];
  List<Category> get incomeAssetTab => _incomeAssetTab;
  //3
  List<Category> _incomeOtherTab = [];
  List<Category> get incomeOtherTab => _incomeOtherTab;
  //4 & 10
  List<Category> _expenseInconsistencyTab = [];
  List<Category> get expenseInconsistencyTab => _expenseInconsistencyTab;
  //5 & 11
  List<Category> _expenseConsistencyTab = [];
  List<Category> get expenseConsistencyTab => _expenseConsistencyTab;
  //6 & 12
  List<Category> _savingAndInvestTab = [];
  List<Category> get savingAndInvestTab => _savingAndInvestTab;

  List<Budget> _budgetList = [];
  List<Budget> get budgetList => _budgetList;

  void setIsIncomePage(int value) {
    _isIncomePage = value;
    notifyListeners();
  }

  void setCategoryList(List<Category> value) {
    _categoryList = value;
  }

  void setCategoryTypes() {
    for (var cat in _categoryList) {
      switch (cat.ftype) {
        case '1':
          _incomeWorking.add(cat);
          break;
        case '2':
          _incomeAsset.add(cat);
          break;
        case '3':
          _incomeOther.add(cat);
          break;
        case '4':
          _expenseInconsistency.add(cat);
          break;
        case '5':
          _expenseConsistency.add(cat);
          break;
        case '6':
          _savingAndInvest.add(cat);
          break;
        case '7':
          _assetLiquid.add(cat);
          break;
        case '8':
          _assetInvestment.add(cat);
          break;
        case '9':
          _assetPrivate.add(cat);
          break;
        case '10':
          _debtShort.add(cat);
          break;
        case '11':
          _debtLong.add(cat);
          break;
        case '12':
          _financialGoal.add(cat);
          break;
        default:
          break;
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

  void setBudgetList(Category cat) {
    final catIndex = _categoryList.indexWhere((e) => e.id == cat.id);
    final isActive = _categoryList[catIndex].active;
    if (isActive == false || isActive == null) {
      Budget budget = Budget(
        catId: cat.id,
        fplan: '',
        balance: 0,
        totalBudget: 1,
        budgetPerPeriod: 2,
        frequency: 'MNY',
        dueDate: '2022-03-31',
      );
      _budgetList.add(budget);
      _categoryList[catIndex].active = true;
    } else {
      _budgetList.removeWhere((e) => e.catId == cat.id);
      _categoryList[catIndex].active = false;
    }
    notifyListeners();
  }

  Color getColorByFtype(String value) {
    Color color;
    switch (value) {
      case '1':
        color = Colors.amber;
        break;
      case '2':
        color = Colors.lightBlue;
        break;
      case '3':
        color = Colors.deepOrange;
        break;
      case '4':
        color = Colors.deepPurple;
        break;
      case '5':
        color = Colors.green;
        break;
      case '6':
        color = Colors.pink;
        break;
      case '7':
        color = Colors.yellow;
        break;
      case '8':
        color = Colors.teal;
        break;
      case '9':
        color = Colors.blueGrey;
        break;
      case '10':
        color = Colors.red;
        break;
      case '11':
        color = Colors.purple;
        break;
      case '12':
        color = Colors.blue;
        break;
      default:
        color = Colors.black;
        break;
    }
    return color;
  }
}
