import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/statement.dart';

class StatementProvider extends ChangeNotifier {
  int _selectedMonth = 0;
  int get selectedMonth => _selectedMonth;

  List<Statement> _statementList = [];
  List<Statement> get statementList => _statementList;

  // String _startDate = '';
  // String _endDate = '';
  // String get startDate => _startDate;
  // String get endDate => _endDate;

  void setStatementList(List<Statement> value) {
    _statementList = value;
    notifyListeners();
  }

  void setSelectedMonth(int value) {
    _selectedMonth = value;
    notifyListeners();
  }

  // void setStartDate(String date) {
  //   _startDate = date;
  //   notifyListeners();
  // }

  // void setEndDate(String date) {
  //   _endDate = date;
  //   notifyListeners();
  // }

  // int getDateDiff() {
  //   final DateTime start = DateFormat('yMd').parse(startDate);
  //   final DateTime end = DateFormat('yMd').parse(endDate);
  //   return start.difference(end).inDays * -1 + 1;
  // }
}
