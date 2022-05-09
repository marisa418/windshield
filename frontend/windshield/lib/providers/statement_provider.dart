import 'package:flutter/material.dart';

import 'package:windshield/models/balance_sheet/flow_sheet.dart';
import 'package:windshield/models/statement/budget.dart';
import 'package:windshield/models/statement/statement.dart';

class StatementProvider extends ChangeNotifier {
  List<StmntStatement> _stmntList = [];
  List<StmntStatement> get stmntList => _stmntList;

  List<FlowSheet> _flowSheetList = [];
  List<FlowSheet> get flowSheetList => _flowSheetList;

  List<StmntStatement> _stmntActiveList = [];
  List<StmntStatement> get stmntActiveList => _stmntActiveList;

  final List<String> _stmntDateChipList = [];
  List<String> get stmntDateChipList => _stmntDateChipList;

  int _stmntDateChipIdx = 0;
  int get stmntDateChipIdx => _stmntDateChipIdx;

  List<StmntStatement> _stmntDateList = [];
  List<StmntStatement> get stmntDateList => _stmntDateList;

  bool _needFetchAPI = false;
  bool get needFetchAPI => _needFetchAPI;

  int _stmntCreatePageIdx = 0;
  int get stmntCreatePageIdx => _stmntCreatePageIdx;

  DateTime _start = DateTime.now();
  DateTime get start => _start;

  DateTime _end = DateTime.parse(DateTime.now().toString());
  DateTime get end => DateTime.parse(_end.toString());

  DateTime _minDate = DateTime.parse(DateTime.now().toString());
  DateTime get minDate => DateTime.parse(_minDate.toString());

  DateTime _maxDate = DateTime.parse(DateTime.now().toString());
  DateTime get maxDate => DateTime.parse(_maxDate.toString());

  String _stmntName = 'แผนงบการเงิน';
  String get stmntName => _stmntName;

  String _stmntId = '';
  String get stmntId => _stmntId;

  List<StmntBudget> _stmntBudgets = [];
  List<StmntBudget> get stmntBudgets => _stmntBudgets;

  bool _editSpecial = false;
  bool get editSpecial => _editSpecial;

  void setStatementList(List<StmntStatement> value) {
    _stmntList = value;
    notifyListeners();
  }

  void setStmntActiveList() {
    _stmntActiveList = [];
    for (var stmnt in _stmntList) {
      if (stmnt.chosen == true) {
        _stmntActiveList.add(stmnt);
      }
    }
    notifyListeners();
  }

  void setStmntDateChipList() {
    for (var i = 0; i < _stmntList.length; i++) {
      final date = '${_stmntList[i].start}|${_stmntList[i].end}';
      if (!_stmntDateChipList.contains(date)) {
        _stmntDateChipList.add(date);
      }
    }
  }

  void setStmntDateChipIdx(int value) {
    _stmntDateChipIdx = value;
    notifyListeners();
  }

  void setStmntDateList() {
    _stmntDateList = [];
    final date = _stmntDateChipList[_stmntDateChipIdx].split('|');
    for (var i = 0; i < _stmntList.length; i++) {
      if (_stmntList[i].start.toString() == date[0] &&
          _stmntList[i].end.toString() == date[1]) {
        _stmntDateList.add(_stmntList[i]);
      }
    }
    final temp = _stmntDateList.firstWhere((e) => e.chosen == true);
    _stmntDateList.removeWhere((e) => e.chosen == true);
    _stmntDateList.insert(0, temp);
    notifyListeners();
  }

  void setNeedFetchAPI() {
    _needFetchAPI = !_needFetchAPI;
    notifyListeners();
  }

  void setStmntCreatePageIdx(int value) {
    _stmntCreatePageIdx = value;
    notifyListeners();
  }

  void setStart(DateTime value) {
    _start = value;
    notifyListeners();
  }

  void setEnd(DateTime value) {
    _end = value;
    notifyListeners();
  }

  void setMinDate(DateTime value) {
    _minDate = value;
    // notifyListeners();
  }

  void setMaxDate(DateTime value) {
    _maxDate = value;
    // notifyListeners();
  }

  void setStmntId(String value) {
    _stmntId = value;
    // notifyListeners();
  }

  void setStmntName(String value) {
    _stmntName = value;
    notifyListeners();
  }

  void setStmntBudgets(List<StmntBudget> value) {
    _stmntBudgets = value;
    notifyListeners();
  }

  int getDateDiff() {
    return _end.difference(_start).inDays + 1;
  }

  String canCreateStmnt() {
    if (getDateDiff() < 21) {
      return 'กรุณาสร้างแผนอย่างต่ำ 21 วัน';
    }
    if (getDateDiff() > 35) {
      return 'กรุณาสร้างแผนไม่เกิน 35 วัน';
    }
    return '';
  }

  void setAvailableDate(DateTime min, DateTime max) {
    _minDate = min;
    _maxDate = max;
    if (_stmntActiveList.isEmpty) {
      _maxDate = DateTime.now().add(const Duration(days: 365));
    }
  }

  void setDate(DateTime start, DateTime end) {
    _start = start;
    _end = end;
    notifyListeners();
  }

  void setEditSpecial(bool value) {
    _editSpecial = value;
    notifyListeners();
  }

  List<double> _incWorking = [0, 0];
  List<double> get incWorking => _incWorking;
  List<double> _incAsset = [0, 0];
  List<double> get incAsset => _incAsset;
  List<double> _incOther = [0, 0];
  List<double> get incOther => _incOther;
  List<double> _expIncon = [0, 0];
  List<double> get expIncon => _expIncon;
  List<double> _expCon = [0, 0];
  List<double> get expCon => _expCon;
  List<double> _savInv = [0, 0];
  List<double> get savInv => _savInv;

  void setFlowSheetList(List<FlowSheet> value) {
    _flowSheetList = value;
    _incWorking = [0, 0];
    _incAsset = [0, 0];
    _incOther = [0, 0];
    _expIncon = [0, 0];
    _expCon = [0, 0];
    _savInv = [0, 0];
    for (var sheet in _flowSheetList) {
      for (var flow in sheet.flows) {
        if (flow.cat.ftype == '1') {
          _incWorking[0] += flow.value;
        } else if (flow.cat.ftype == '2' ||
            flow.cat.ftype == '8' ||
            flow.cat.ftype == '9') {
          _incAsset[0] += flow.value;
        } else if (flow.cat.ftype == '3') {
          _incOther[0] += flow.value;
        } else if (flow.cat.ftype == '4' || flow.cat.ftype == '10') {
          _expIncon[0] += flow.value;
        } else if (flow.cat.ftype == '5' || flow.cat.ftype == '11') {
          _expCon[0] += flow.value;
        } else if (flow.cat.ftype == '6' || flow.cat.ftype == '12') {
          _savInv[0] += flow.value;
        }
      }
    }
    for (var bud in _stmntList[0].budgets) {
      if (bud.cat.ftype == '1') {
        _incWorking[1] += bud.total;
      } else if (bud.cat.ftype == '2' ||
          bud.cat.ftype == '8' ||
          bud.cat.ftype == '9') {
        _incAsset[1] += bud.total;
      } else if (bud.cat.ftype == '3') {
        _incOther[1] += bud.total;
      } else if (bud.cat.ftype == '4' || bud.cat.ftype == '10') {
        _expIncon[1] += bud.total;
      } else if (bud.cat.ftype == '5' || bud.cat.ftype == '11') {
        _expCon[1] += bud.total;
      } else if (bud.cat.ftype == '6' || bud.cat.ftype == '12') {
        _savInv[1] += bud.total;
      }
    }
  }
}
