import 'package:flutter/material.dart';
import 'inc_exp_model.dart';

class IncExpProvider extends ChangeNotifier {
  List<IncExpGraph> _graph = [];
  List<IncExpGraph> get graph => _graph;

  IncExp _incExp = IncExp(
    avgInc: 0,
    avgIncWorking: 0,
    avgIncAsset: 0,
    avgIncOther: 0,
    avgExp: 0,
    avgExpInconsist: 0,
    avgExpConsist: 0,
    avgSavInv: 0,
  );
  IncExp get incExp => _incExp;

  int _range = 30;
  int get range => _range;

  final List<String> _typeList = ['daily', 'monthly', 'annually'];
  List<String> get typeList => _typeList;
  String _type = 'daily';
  String get type => _type;

  void setGraph(List<IncExpGraph> value) {
    _graph = value;
    notifyListeners();
  }

  void setIncExp(IncExp value) {
    _incExp = value;
    notifyListeners();
  }

  void setRange(int value) {
    _range = value;
    notifyListeners();
  }

  void setType(String value) {
    _type = value;
    notifyListeners();
  }
}
