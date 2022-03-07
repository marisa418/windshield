import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:windshield/models/statement.dart';

class StatementProvider extends ChangeNotifier {
  List<Statement> _stmntList = [];
  List<Statement> get stmntList => _stmntList;

  List<Statement> _stmntActiveList = [];
  List<Statement> get stmntActiveList => _stmntActiveList;

  List<String> _stmntDateChipList = [];
  List<String> get stmntDateChipList => _stmntDateChipList;

  int _stmntDateChipIdx = 0;
  int get stmntDateChipIdx => _stmntDateChipIdx;

  List<Statement> _stmntDateList = [];
  List<Statement> get stmntDateList => _stmntDateList;

  bool _needFetchAPI = false;
  bool get needFetchAPI => _needFetchAPI;

  int _stmntCreatePageIdx = 0;
  int get stmntCreatePageIndex => _stmntCreatePageIdx;

  DateTime _start = DateFormat('y-MM-dd').parse(DateTime.now().toString());
  DateTime get start => DateFormat('y-MM-dd').parse(_start.toString());

  DateTime _end = DateFormat('y-MM-dd').parse(DateTime.now().toString());
  DateTime get end => DateFormat('y-MM-dd').parse(_end.toString());

  DateTime _minDate = DateFormat('y-MM-dd').parse(DateTime.now().toString());
  DateTime get minDate => DateFormat('y-MM-dd').parse(_minDate.toString());

  DateTime _maxDate = DateFormat('y-MM-dd').parse(DateTime.now().toString());
  DateTime get maxDate => DateFormat('y-MM-dd').parse(_maxDate.toString());

  String _stmntName = 'แผนงบการเงิน';
  String get stmntName => _stmntName;

  String _stmntId = '';
  String get stmntId => _stmntId;

  void setStatementList(List<Statement> value) {
    _stmntList = value;
    // notifyListeners();
  }

  void setStmntActiveList() {
    for (var stmnt in _stmntList) {
      if (stmnt.chosen == true) {
        _stmntActiveList.add(stmnt);
      }
    }
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
    final date = _stmntDateChipList[_stmntDateChipIdx].split('|');
    for (var i = 0; i < _stmntList.length; i++) {
      if (_stmntList[i].start.toString() == date[0]) {
        _stmntDateList.add(_stmntList[i]);
      }
    }
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
    _start = DateFormat('y-MM-dd').parse(value.toString());
    notifyListeners();
  }

  void setEnd(DateTime value) {
    _end = DateFormat('y-MM-dd').parse(value.toString());
    notifyListeners();
  }

  void setMinDate(DateTime value) {
    _minDate = DateFormat('y-MM-dd').parse(value.toString());
    // notifyListeners();
  }

  void setMaxDate(DateTime value) {
    _maxDate = DateFormat('y-MM-dd').parse(value.toString());
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

  int getDateDiff() {
    return _end.difference(_start).inDays + 1;
  }

  bool canCreateStmnt() {
    if (getDateDiff() <= 35 && getDateDiff() >= 21) {
      return true;
    }
    return false;
  }
}
