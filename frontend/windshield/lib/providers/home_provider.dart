import 'package:flutter/cupertino.dart';

import 'package:windshield/models/balance_sheet/flow_sheet.dart';
import 'package:windshield/models/statement/statement.dart';

class HomeProvider extends ChangeNotifier {
  List<StmntStatement> _stmntList = [];
  List<StmntStatement> get stmntList => _stmntList;

  List<FlowSheet> _flowSheetList = [];
  List<FlowSheet> get flowSheetList => _flowSheetList;

  final List<double> _incWorking = [0, 0];
  List<double> get incWorking => _incWorking;
  final List<double> _incAsset = [0, 0];
  List<double> get incAsset => _incAsset;
  final List<double> _incOther = [0, 0];
  List<double> get incOther => _incOther;
  final List<double> _expIncon = [0, 0];
  List<double> get expIncon => _expIncon;
  final List<double> _expCon = [0, 0];
  List<double> get expCon => _expCon;
  final List<double> _savInv = [0, 0];
  List<double> get savInv => _savInv;

  bool _needFetchAPI = false;
  bool get needFetchAPI => _needFetchAPI;

  void setStatementList(List<StmntStatement> value) {
    _stmntList = value;
    notifyListeners();
  }

  void setFlowSheetList(List<FlowSheet> value) {
    _flowSheetList = value;
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
    notifyListeners();
  }

  void setNeedFetchAPI() {
    _needFetchAPI = !_needFetchAPI;
    notifyListeners();
  }
}
