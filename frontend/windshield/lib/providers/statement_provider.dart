import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:windshield/models/statement.dart';

class StatementProvider extends ChangeNotifier {
  int _statementMonthIndex = 0;
  int get statementMonthIndex => _statementMonthIndex;

  List<Statement> _statementList = [];
  List<Statement> get statementList => _statementList;

  List<Statement> _statementsInMonth = [];
  List<Statement> get statementsInMonth => _statementsInMonth;

  List<int> _existedMonth = [];
  List<int> get existedMonth => _existedMonth;

  int _createPageIndex = 0;
  int get createPageIndex => _createPageIndex;

  String _startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String get startDate => _startDate;
  String get endDate => _endDate;

  String _statementName = 'แผนการเงินที่ 1';
  String get statementName => _statementName;

  bool _needUpdated = false;
  bool get needUpdated => _needUpdated;

  bool _twoMonthLimited = true;
  bool get twoMonthLimited => _twoMonthLimited;

  bool _skipDatePage = false;
  bool get skipDatePage => _skipDatePage;

  void setStatementList(List<Statement> value) {
    _statementList = value;
    // notifyListeners();
  }

  void setExistedMonth() {
    List<int> month = [];
    for (var item in _statementList) {
      if (!month.contains(item.month)) {
        month.add(item.month);
      }
    }
    _existedMonth = month;
    notifyListeners();
  }

  void setStatementMonthIndex(int value) {
    _statementMonthIndex = value;
    notifyListeners();
  }

  void setStatementsInMonth() {
    List<Statement> statements = [];
    for (var item in _statementList) {
      if (item.month == _existedMonth[_statementMonthIndex]) {
        statements.add(item);
      }
    }
    if (_statementList.length != 1) {
      Statement temp = Statement(
        id: '',
        name: '',
        chosen: false,
        start: '',
        end: '',
        month: 0,
      );
      statements.add(temp);
    }
    _statementsInMonth = statements;
    notifyListeners();
  }

  void setCreatePageIndex(int value) {
    _createPageIndex = value;
    notifyListeners();
  }

  void setStartDate(String date) {
    _startDate = date;
    notifyListeners();
  }

  void setEndDate(String date) {
    _endDate = date;
    notifyListeners();
  }

  void setStatementName(String name) {
    _statementName = name;
    notifyListeners();
  }

  void setTwoMonthLimited(bool value) {
    _twoMonthLimited = value;
  }

  void setSkipDatePage(bool value) {
    _skipDatePage = value;
  }

  int getDateDiff() {
    final DateTime start = DateFormat('yyyy-MM-dd').parse(_startDate);
    final DateTime end = DateFormat('yyyy-MM-dd').parse(_endDate);
    return (start.difference(end).inDays * -1 + 1).abs();
  }

  void setNeedUpdate() {
    _needUpdated = !_needUpdated;
    notifyListeners();
  }
}
