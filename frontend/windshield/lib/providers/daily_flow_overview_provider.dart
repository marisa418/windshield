import 'package:flutter/material.dart';

import 'package:windshield/models/daily_flow/category.dart';

class DailyFlowOverviewProvider extends ChangeNotifier {
  List<DFlowCategory> _catList = [];
  List<DFlowCategory> get catList => _catList;

  String _dfId = '';
  String get dfId => _dfId;

  int _pageIdx = 0;
  int get pageIdx => _pageIdx;

  double _incTotal = 0;
  double get incTotal => _incTotal;
  int _incFlowsLen = 0;
  int get incFlowsLen => _incFlowsLen;
  double _expTotal = 0;
  double get expTotal => _expTotal;
  int _expFlowsLen = 0;
  int get expFlowsLen => _expFlowsLen;

  DateTime _date = DateTime.now();
  DateTime get date => _date;

  //1
  final List<DFlowCategory> _incWorkingList = [];
  List<DFlowCategory> get incWorkingList => _incWorkingList;
  double _incWorkingTotal = 0;
  double get incWorkingTotal => _incWorkingTotal;
  //2
  final List<DFlowCategory> _incAssetList = [];
  List<DFlowCategory> get incAssetList => _incAssetList;
  double _incAssetTotal = 0;
  double get incAssetTotal => _incAssetTotal;
  //3
  final List<DFlowCategory> _incOtherList = [];
  List<DFlowCategory> get incOtherList => _incOtherList;
  double _incOtherTotal = 0;
  double get incOtherTotal => _incOtherTotal;
  //4, 10
  final List<DFlowCategory> _expInconList = [];
  List<DFlowCategory> get expInconList => _expInconList;
  double _expInconTotal = 0;
  double get expInconTotal => _expInconTotal;
  //5, 11
  final List<DFlowCategory> _expConList = [];
  List<DFlowCategory> get expConList => _expConList;
  double _expConTotal = 0;
  double get expConTotal => _expConTotal;
  //6, 12
  final List<DFlowCategory> _savAndInvList = [];
  List<DFlowCategory> get savAndInvList => _savAndInvList;
  double _savAndInvTotal = 0;
  double get savAndInvTotal => _savAndInvTotal;

  bool _needFetchAPI = false;
  bool get needFetchAPI => _needFetchAPI;

  final List<DFlowCategory> _tdIncList = [];
  List<DFlowCategory> get tdIncList => _tdIncList;
  final List<DFlowCategory> _tdExpList = [];
  List<DFlowCategory> get tdExpList => _tdExpList;

  void setCatList(List<DFlowCategory> value) {
    _catList = value;
  }

  void setDfId(String value) {
    _dfId = value;
  }

  void setPageIdx(int value) {
    _pageIdx = value;
    notifyListeners();
  }

  void setNeedFetchAPI() {
    _needFetchAPI = !_needFetchAPI;
    notifyListeners();
  }

  void setCatType() {
    _incWorkingTotal = 0;
    _incAssetTotal = 0;
    _incOtherTotal = 0;
    _expInconTotal = 0;
    _expConTotal = 0;
    _savAndInvTotal = 0;
    _incFlowsLen = 0;
    _expFlowsLen = 0;
    _incWorkingList.clear();
    _incAssetList.clear();
    _incOtherList.clear();
    _expInconList.clear();
    _expConList.clear();
    _savAndInvList.clear();
    _tdIncList.clear();
    _tdExpList.clear();
    for (var cat in _catList) {
      if (cat.ftype == '1') {
        _incWorkingList.add(cat);
        for (var flow in cat.flows) {
          _incWorkingTotal += flow.value;
          _incFlowsLen++;
          if (_tdIncList.any((e) => e.id == cat.id)) continue;
          _tdIncList.add(cat);
        }
      } else if (cat.ftype == '2' || cat.ftype == '8' || cat.ftype == '9') {
        _incAssetList.add(cat);
        for (var flow in cat.flows) {
          _incAssetTotal += flow.value;
          _incFlowsLen++;
          if (_tdIncList.any((e) => e.id == cat.id)) continue;
          _tdIncList.add(cat);
        }
      } else if (cat.ftype == '3') {
        _incOtherList.add(cat);
        for (var flow in cat.flows) {
          _incOtherTotal += flow.value;
          _incFlowsLen++;
          if (_tdIncList.any((e) => e.id == cat.id)) continue;
          _tdIncList.add(cat);
        }
      } else if (cat.ftype == '4' || cat.ftype == '10') {
        _expInconList.add(cat);
        for (var flow in cat.flows) {
          _expInconTotal += flow.value;
          _expFlowsLen++;
          if (_tdExpList.any((e) => e.id == cat.id)) continue;
          _tdExpList.add(cat);
        }
      } else if (cat.ftype == '5' || cat.ftype == '11') {
        _expConList.add(cat);
        for (var flow in cat.flows) {
          _expConTotal += flow.value;
          _expFlowsLen++;
          if (_tdExpList.any((e) => e.id == cat.id)) continue;
          _tdExpList.add(cat);
        }
      } else if (cat.ftype == '6' || cat.ftype == '12') {
        _savAndInvList.add(cat);
        for (var flow in cat.flows) {
          _savAndInvTotal += flow.value;
          _expFlowsLen++;
          if (_tdExpList.any((e) => e.id == cat.id)) continue;
          _tdExpList.add(cat);
        }
      }
    }
    _incTotal = _incWorkingTotal + _incAssetTotal + _incOtherTotal;
    _expTotal = _expInconTotal + _expConTotal + _savAndInvTotal;
    notifyListeners();
  }

  void setDate(DateTime value) {
    _date = value;
    notifyListeners();
  }
}
