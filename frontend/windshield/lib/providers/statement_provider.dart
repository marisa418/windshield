import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:windshield/models/statement/budget.dart';
import 'package:windshield/models/statement/category.dart';

import 'package:windshield/models/statement/statement.dart';

class StatementProvider extends ChangeNotifier {
  List<StmntStatement> _stmntList = [];
  List<StmntStatement> get stmntList => _stmntList;

  List<StmntStatement> _stmntActiveList = [];
  List<StmntStatement> get stmntActiveList => _stmntActiveList;

  List<String> _stmntDateChipList = [];
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

  // TEMP ======================================================================
  StmntStatement stmntTemp = StmntStatement(
    id: '',
    name: '',
    chosen: false,
    start: DateTime.now(),
    end: DateTime.now(),
    budgets: [
      StmntBudget(
        id: '',
        catId: '',
        balance: 0,
        total: 0,
        budPerPeriod: 0,
        freq: '',
        fplan: '',
        cat: StmntCategory(id: '', name: '', usedCount: 0, ftype: '', icon: ''),
      ),
    ],
  );
  //============================================================================

  void setStatementList(List<StmntStatement> value) {
    _stmntList = value;
    // notifyListeners();
  }

  void setStmntActiveList() {
    _stmntActiveList = [];
    for (var stmnt in _stmntList) {
      if (stmnt.chosen == true) {
        _stmntActiveList.add(stmnt);
      }
    }
    notifyListeners();
    // _stmntActiveList.add(stmntTemp);
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

  bool canCreateStmnt() {
    if (getDateDiff() <= 35 && getDateDiff() >= 21) {
      return true;
    }
    return false;
  }

  void setAvailableDate(DateTime min, DateTime max) {
    _minDate = min;
    _maxDate = max;
  }

  void setDate(DateTime start, DateTime end) {
    _start = start;
    _end = end;
    notifyListeners();
  }
}
