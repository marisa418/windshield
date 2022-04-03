import 'package:flutter/material.dart';

import 'package:windshield/models/balance_sheet/balance_sheet.dart';
import 'package:windshield/models/balance_sheet/asset.dart';
import 'package:windshield/models/balance_sheet/debt.dart';
import 'package:windshield/models/statement/category.dart';

class BalanceSheetProvider extends ChangeNotifier {
  late BSheetBalance _bs;
  BSheetBalance get bs => _bs;

  List<StmntCategory> _cat = [];
  List<StmntCategory> get cat => _cat;

  int _pageIdx = 0;
  int get pageIdx => _pageIdx;

  double _balTotal = 0;
  double get balTotal => _balTotal;
  double _assTotal = 0;
  double get assTotal => _assTotal;
  double _debtTotal = 0;
  double get debtTotal => _debtTotal;

  // ftype = 7
  final List<BSheetAsset> _assLiquidList = [];
  List<BSheetAsset> get assLiquidList => _assLiquidList;
  double _assLiquidTotal = 0;
  double get assLiquidTotal => _assLiquidTotal;
  final List<StmntCategory> _catAssLiquidList = [];
  List<StmntCategory> get catAssLiquidList => _catAssLiquidList;
  // 8
  final List<BSheetAsset> _assInvestList = [];
  List<BSheetAsset> get assInvestList => _assInvestList;
  double _assInvestTotal = 0;
  double get assInvestTotal => _assInvestTotal;
  final List<StmntCategory> _catAssInvestList = [];
  List<StmntCategory> get catAssInvestList => _catAssInvestList;
  // 9
  final List<BSheetAsset> _assPrivateList = [];
  List<BSheetAsset> get assPrivateList => _assPrivateList;
  double _assPrivateTotal = 0;
  double get assPrivateTotal => _assPrivateTotal;
  final List<StmntCategory> _catAssPrivateList = [];
  List<StmntCategory> get catAssPrivateList => _catAssPrivateList;
  // 10
  final List<BSheetDebt> _debtShortList = [];
  List<BSheetDebt> get debtShortList => _debtShortList;
  double _debtShortTotal = 0;
  double get debtShortTotal => _debtShortTotal;
  final List<StmntCategory> _catDebtShortList = [];
  List<StmntCategory> get catDebtShortList => _catDebtShortList;
  // 11
  final List<BSheetDebt> _debtLongList = [];
  List<BSheetDebt> get debtLongList => _debtLongList;
  double _debtLongTotal = 0;
  double get debtLongTotal => _debtLongTotal;
  final List<StmntCategory> _catDebtLongList = [];
  List<StmntCategory> get catDebtLongList => _catDebtLongList;

  bool _needFetchAPI = false;
  bool get needFetchAPI => _needFetchAPI;

  int _createIdx = 0;
  int get createIdx => _createIdx;
  StmntCategory _currCat =
      StmntCategory(id: '', name: '', usedCount: 0, ftype: '', icon: '');
  StmntCategory get currCat => _currCat;

  double _value = 0;
  double get value => _value;
  String _source = '';
  String get source => _source;
  List<StmntCategory> _createCatList = [];
  List<StmntCategory> get createCatList => _createCatList;
  String _id = '';
  String get id => _id;

  double _balance = 0;
  double get balance => _balance;
  String _creditor = '';
  String get creditor => _creditor;
  double _interest = 0;
  double get interest => _interest;
  DateTime _debtTerm = DateTime.now();
  DateTime get debtTerm => _debtTerm;

  void setBs(BSheetBalance value) {
    _bs = value;
  }

  void setCat(List<StmntCategory> value) {
    _cat = value;
  }

  void setPageIdx() {
    if (_pageIdx == 0) {
      _pageIdx = 1;
    } else {
      _pageIdx = 0;
    }
    notifyListeners();
  }

  void setBsType() {
    _assLiquidTotal = 0;
    _assInvestTotal = 0;
    _assPrivateTotal = 0;
    _debtShortTotal = 0;
    _debtLongTotal = 0;
    _assLiquidList.clear();
    _assInvestList.clear();
    _assPrivateList.clear();
    _debtShortList.clear();
    _debtLongList.clear();
    for (var item in _bs.assets) {
      if (item.cat.ftype == '7') {
        _assLiquidList.add(item);
        _assLiquidTotal += item.recentVal;
      } else if (item.cat.ftype == '8') {
        _assInvestList.add(item);
        _assInvestTotal += item.recentVal;
      } else if (item.cat.ftype == '9') {
        _assPrivateList.add(item);
        _assPrivateTotal += item.recentVal;
      }
    }
    for (var item in _bs.debts) {
      if (item.cat.ftype == '10') {
        _debtShortList.add(item);
        _debtShortTotal += item.balance;
      } else if (item.cat.ftype == '11') {
        _debtLongList.add(item);
        _debtLongTotal += item.balance;
      }
    }
    _assTotal = _assLiquidTotal + _assInvestTotal + _assPrivateTotal;
    _debtTotal = _debtShortTotal + _debtLongTotal;
    _balTotal = _assTotal - _debtTotal;
    notifyListeners();
  }

  void setCatType() {
    _catAssLiquidList.clear();
    _catAssInvestList.clear();
    _catAssPrivateList.clear();
    _catDebtShortList.clear();
    _catDebtLongList.clear();
    for (var item in _cat) {
      if (item.ftype == '7') {
        _catAssLiquidList.add(item);
      } else if (item.ftype == '8') {
        _catAssInvestList.add(item);
      } else if (item.ftype == '9') {
        _catAssPrivateList.add(item);
      } else if (item.ftype == '10') {
        _catDebtShortList.add(item);
      } else if (item.ftype == '11') {
        _catDebtLongList.add(item);
      }
    }
    notifyListeners();
  }

  void setNeedFetchAPI() {
    _needFetchAPI = !_needFetchAPI;
    notifyListeners();
  }

  void setCreateIdx(int value) {
    _createIdx = value;
    notifyListeners();
  }

  void setCurrCat(StmntCategory value) {
    _currCat = value;
    notifyListeners();
  }

  void setValue(double value) {
    _value = value;
    notifyListeners();
  }

  void setSource(String value) {
    _source = value;
    notifyListeners();
  }

  void setCreateCatList(List<StmntCategory> value) {
    _createCatList = value;
    notifyListeners();
  }

  void setId(String value) {
    _id = value;
    notifyListeners();
  }

  void setBalance(double value) {
    _balance = value;
    notifyListeners();
  }

  void setCreditor(String value) {
    _creditor = value;
    notifyListeners();
  }

  void setInterest(double value) {
    _interest = value;
    notifyListeners();
  }

  void setDebtTerm(DateTime value) {
    _debtTerm = value;
    notifyListeners();
  }
}
