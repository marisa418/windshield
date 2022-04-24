import 'package:flutter/material.dart';
import 'package:windshield/models/balance_sheet/flow_sheet.dart';
import 'package:windshield/models/daily_flow/budget.dart';

import 'package:windshield/models/daily_flow/category.dart';
import 'package:windshield/models/daily_flow/flow.dart';
import 'package:windshield/models/statement/category.dart';

class DailyFlowProvider extends ChangeNotifier {
  List<DFlowCategory> _catList = [];
  List<DFlowCategory> get catList => _catList;

  double _incTotal = 0;
  double get incTotal => _incTotal;
  double _expTotal = 0;
  double get expTotal => _expTotal;
  String _colorBackground = 'income';
  String get colorBackground => _colorBackground;

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

  List<FlowSheet> _oldFlowSheetList = [];
  List<FlowSheet> get oldFlowSheetList => _oldFlowSheetList;

  DFlowCategory _currCat = DFlowCategory(
    id: '',
    name: '',
    usedCount: 0,
    ftype: '',
    icon: '',
    budgets: [
      DFlowBudget(
        id: '',
        catId: '',
        total: 0,
        budPerPeriod: 0,
        freq: '',
        fplan: '',
      ),
    ],
    flows: [
      DFlowFlow(
        id: '',
        method: Method(id: 0, name: '', icon: ''),
        name: '',
        value: 0,
        detail: '',
        dfId: '',
        cat: Cat(id: '', name: '', usedCount: 0, icon: '', ftype: ''),
      ),
    ],
  );
  DFlowCategory get currCat => _currCat;

  String _flowId = '';
  String get flowId => _flowId;

  String _flowName = '';
  String get flowName => _flowName;

  double _flowValue = 0;
  double get flowValue => _flowValue;

  int _flowMethod = 0;
  int get flowMethod => _flowMethod;

  bool _needFetchAPI = false;
  bool get needFetchAPI => _needFetchAPI;

  void setCatList(List<DFlowCategory> value) {
    _catList = value;
  }

  void setColorBackground(String value) {
    _colorBackground = value;
    notifyListeners();
  }

  void setCurrCat(DFlowCategory value) {
    _currCat = value;
    notifyListeners();
  }

  void setFlowId(String value) {
    _flowId = value;
    notifyListeners();
  }

  void setFlowName(String value) {
    _flowName = value;
    notifyListeners();
  }

  void setFlowValue(double value) {
    _flowValue = value;
    notifyListeners();
  }

  void setFlowMethod(int value) {
    _flowMethod = value;
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
    _incWorkingList.clear();
    _incAssetList.clear();
    _incOtherList.clear();
    _expInconList.clear();
    _expConList.clear();
    _savAndInvList.clear();
    for (var cat in _catList) {
      if (cat.ftype == '1') {
        _incWorkingList.add(cat);
        for (var flow in cat.flows) {
          _incWorkingTotal += flow.value;
        }
      } else if (cat.ftype == '2' || cat.ftype == '8' || cat.ftype == '9') {
        _incAssetList.add(cat);
        for (var flow in cat.flows) {
          _incAssetTotal += flow.value;
        }
      } else if (cat.ftype == '3') {
        _incOtherList.add(cat);
        for (var flow in cat.flows) {
          _incOtherTotal += flow.value;
        }
      } else if (cat.ftype == '4' || cat.ftype == '10') {
        _expInconList.add(cat);
        for (var flow in cat.flows) {
          _expInconTotal += flow.value;
        }
      } else if (cat.ftype == '5' || cat.ftype == '11') {
        _expConList.add(cat);
        for (var flow in cat.flows) {
          _expConTotal += flow.value;
        }
      } else if (cat.ftype == '6' || cat.ftype == '12') {
        _savAndInvList.add(cat);
        for (var flow in cat.flows) {
          _savAndInvTotal += flow.value;
        }
      }
    }
    _incTotal = _incWorkingTotal + _incAssetTotal + _incOtherTotal;
    _expTotal = _expInconTotal + _expConTotal + _savAndInvTotal;
    notifyListeners();
  }

  void setOldFlowSheetList(List<FlowSheet> value) {
    _oldFlowSheetList = value;
    notifyListeners();
  }

  List<StmntCategory> categorizeOldFlow(FlowSheet value, String name) {
    List<StmntCategory> catList = [];
    for (var flow in value.flows) {
      final catIdx = catList.indexWhere((e) => e.id == flow.cat.id);
      final ftype = convertNameToFtype(name);
      if (catIdx == -1 && ftype.contains(flow.cat.ftype)) {
        final StmntCategory cat = StmntCategory(
          id: flow.cat.id,
          name: flow.cat.name,
          usedCount: flow.cat.usedCount,
          ftype: flow.cat.ftype,
          icon: flow.cat.icon,
        );
        cat.total = flow.value;
        catList.add(cat);
      } else {
        if (ftype.contains(flow.cat.ftype)) {
          catList[catIdx].total += flow.value;
        }
      }
    }
    return catList;
  }

  List<String> convertNameToFtype(String value) {
    if (value == 'รายรับ') return ['1', '2', '3', '8', '9'];
    if (value == 'รายจ่าย') return ['4', '5', '6', '10', '11', '12'];
    if (value == 'รายรับจากการทำงาน') return ['1'];
    if (value == 'รายรับจากสินทรัพย์') return ['2', '8', '9'];
    if (value == 'รายรับอื่นๆ') return ['3'];
    if (value == 'รายจ่ายไม่คงที่') return ['4', '10'];
    if (value == 'รายจ่ายคงที่') return ['5', '11'];
    if (value == 'การออมและการลงทุน') return ['6', '12'];
    return [];
  }

  void addFlow(DFlowFlow flow) {
    _currCat.flows.add(flow);
    notifyListeners();
  }

  void editFlow(DFlowFlow flow) {
    final found = _currCat.flows.firstWhere((e) => e.id == flow.id);
    found.cat = flow.cat;
    found.detail = flow.detail;
    found.dfId = flow.dfId;
    found.id = flow.id;
    found.method = flow.method;
    found.methodId = flow.methodId;
    found.name = flow.name;
    found.value = flow.value;
    notifyListeners();
  }

  void removeFlow(String flowId) {
    _currCat.flows.removeWhere((e) => e.id == flowId);
    notifyListeners();
  }
}
