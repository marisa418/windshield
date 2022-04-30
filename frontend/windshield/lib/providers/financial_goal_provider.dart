import 'package:flutter/material.dart';
import 'package:windshield/models/financial_goal/financial_goal.dart';

class FinancialGoalProvider extends ChangeNotifier {
  List<FGoal> _fgList = [];
  List<FGoal> get fgList => _fgList;

  String _name = "";
  String get name => _name;

  double _goal = 0;
  double get goal => _goal;

  double _totalProg = 0;
  double get totalProg => _totalProg;

  double _progPerPeriod = 0;
  double get progPerPeriod => _progPerPeriod;

  String _periodTerm = "ALY";
  String get periodTerm => _periodTerm;

  DateTime _start = DateTime.now();
  DateTime get start => _start;
  bool _isStart = false;
  bool get isStart => _isStart;

  DateTime? _goalDate;
  DateTime? get goalDate => _goalDate;

  String _id = '';
  String get id => _id;

  int? _dateDiff;
  int? get dateDiff => _dateDiff;

  final List<FGoal> _startedFg = [];
  List<FGoal> get startedFg => _startedFg;

  final List<FGoal> _notStartFg = [];
  List<FGoal> get notStartFg => _notStartFg;

  final List<FGoal> _finishedFg = [];
  List<FGoal> get finishedFg => _finishedFg;

  bool _needFetchAPI = false;
  bool get needFetchAPI => _needFetchAPI;

  bool _isAdd = true;
  bool get isAdd => _isAdd;

  int _pageindex = 0;
  int get pageindex => _pageindex;

  bool _isMainForm = true;
  bool get isMainForm => _isMainForm;

  void setFgList(List<FGoal> value) {
    _fgList = value;
  }

  void setFgType() {
    _finishedFg.clear();
    _notStartFg.clear();
    _startedFg.clear();
    for (var item in _fgList) {
      if (item.totalProg >= item.goal) {
        _finishedFg.add(item);
      } else if (item.start.difference(DateTime.now()).inDays > 0) {
        _notStartFg.add(item);
      } else if (item.start.difference(DateTime.now()).inDays <= 0) {
        _startedFg.add(item);
      }
    }
    notifyListeners();
  }

  void setPageindex(int value) {
    _pageindex = value;
    notifyListeners();
  }

  void setIsMainForm(bool value) {
    _isMainForm = value;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setGoal(double value) {
    _goal = value;
    notifyListeners();
  }

  void setTotalProg(double value) {
    _totalProg = value;
    notifyListeners();
  }

  void setProgPerPeriod(double value) {
    _progPerPeriod = value;
    notifyListeners();
  }

  void setPeriodTerm(String value) {
    _periodTerm = value;
    notifyListeners();
  }

  void setStart(DateTime value) {
    _start = value;
    notifyListeners();
  }

  void setIsStart(bool value) {
    _isStart = value;
    notifyListeners();
  }

  void setGoalDate(DateTime? value) {
    _goalDate = value;
    notifyListeners();
  }

  void setId(String value) {
    _id = value;
  }

  void setDateDiff(int? value) {
    _dateDiff = value;
    notifyListeners();
  }

  void setIsAdd(bool value) {
    _isAdd = value;
    notifyListeners();
  }

  void setNeedFetchAPI() {
    _needFetchAPI = !_needFetchAPI;
    notifyListeners();
  }
}
