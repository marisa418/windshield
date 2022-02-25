import 'package:flutter/material.dart';

import 'package:windshield/models/category.dart';

class CategoryProvider extends ChangeNotifier {
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
      } else if (cat.ftype == '4' && cat.ftype == '10') {
        _expenseInconsistencyTab.add(cat);
      } else if (cat.ftype == '5' && cat.ftype == '11') {
        _expenseConsistencyTab.add(cat);
      } else if (cat.ftype == '6' && cat.ftype == '12') {
        _savingAndInvestTab.add(cat);
      }
    }
  }
}
