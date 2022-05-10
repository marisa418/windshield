import 'package:flutter/material.dart';

import 'budget_model.dart';

class BudgetProvider extends ChangeNotifier {
  List<Budget> _statementList = [];
  List<Budget> get statementList => _statementList;

  void setStatementList(List<Budget> value) {
    _statementList = value;
    notifyListeners();
  }
}
