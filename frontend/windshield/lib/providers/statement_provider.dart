import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:windshield/models/statement.dart';

class StatementProvider extends ChangeNotifier {
  int _selectedMonth = 0;
  int get selectedMonth => _selectedMonth;

  List<Statement> _statementList = [];
  List<Statement> get statementList => _statementList;

  List<Statement> _statementsInMonth = [];
  List<Statement> get statementsInMonth => _statementsInMonth;

  List<int> _existedMonth = [];
  List<int> get existedMonth => _existedMonth;

  int _createPageIndex = 0;
  int get createPageIndex => _createPageIndex;

  String _startDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  String _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  String get startDate => _startDate;
  String get endDate => _endDate;

  void setStatementList(List<Statement> value) {
    _statementList = value;
    // notifyListeners();
  }

  void setSelectedMonth(int value) {
    _selectedMonth = value;
    notifyListeners();
  }

  void setExistedMonth(List<Statement> value) {
    List<int> month = [];
    for (var item in value) {
      if (!month.contains(item.month)) {
        month.add(item.month);
      }
    }
    _existedMonth = month;
    notifyListeners();
  }

  void setExistedStatements() {
    List<Statement> statements = [];
    for (var item in _statementList) {
      if (item.month == _selectedMonth) {
        statements.add(item);
      }
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

  int getDateDiff() {
    final DateTime start = DateFormat('yyyy-MM-dd').parse(startDate);
    final DateTime end = DateFormat('yyyy-MM-dd').parse(endDate);
    return (start.difference(end).inDays * -1 + 1).abs();
  }
}
