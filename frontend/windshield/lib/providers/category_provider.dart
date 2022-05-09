import 'package:flutter/material.dart';
import 'package:windshield/models/statement/category.dart';

class CategoryProvider extends ChangeNotifier {  
  List<StmntCategory> _cat = [];
  List<StmntCategory> get cat => _cat;
  
  // ftype = 1 /
  final List<StmntCategory> _incWorkingList = [];
  List<StmntCategory> get incWorkingList => _incWorkingList;
  // ftype = 2 /
  final List<StmntCategory> _incAssetList = [];
  List<StmntCategory> get incAssetList => _incAssetList;
  // ftype = 3 /
  final List<StmntCategory> _incOtherList = [];
  List<StmntCategory> get incOtherList => _incOtherList;
  // ftype = 4 /
  final List<StmntCategory> _expInconsistList = [];
  List<StmntCategory> get expInconsistList => _expInconsistList;
  // ftype = 5 /
  final List<StmntCategory> _expConsistList = [];
  List<StmntCategory> get expConsistList => _expConsistList;
  // ftype = 6 /
  final List<StmntCategory> _savInvList = [];
  List<StmntCategory> get savInvList => _savInvList;
  // ftype = 7 /
  final List<StmntCategory> _assLiquidList = [];
  List<StmntCategory> get assLiquidList => _assLiquidList;
  // 8
  
  final List<StmntCategory> _assInvestList = [];
  List<StmntCategory> get assInvestList => _assInvestList;
  // 9
  
  final List<StmntCategory> _assPrivateList = [];
  List<StmntCategory> get assPrivateList => _assPrivateList;
  // 10
  
  final List<StmntCategory> _debtShortList = [];
  List<StmntCategory> get debtShortList => _debtShortList;
  // 11
  
  final List<StmntCategory> _debtLongList = [];
  List<StmntCategory> get debtLongList => _debtLongList;

  // 12 เป้าหมาย
  
  final List<StmntCategory> _goalList = [];
  List<StmntCategory> get goalList => _goalList;

  bool _isAdd = true;
  bool get isAdd => _isAdd;
  
  String _id = '';
  String get id => _id;
  String _name ='';
  String get name => _name;
  String _icon ='';
  String get icon => _icon;
  String _ftype ='';
  String get ftype => _ftype;

  StmntCategory _currCat =
      StmntCategory(id: '', name: '', usedCount: 0, ftype: '', icon: '');
  StmntCategory get currCat => _currCat;

  String _curFtype = '';
  String get curFtype => _curFtype;


  

  bool _needFetchAPI = false;
  bool get needFetchAPI => _needFetchAPI;

  void setIsAdd(bool value) {
    _isAdd = value;
    notifyListeners();
  }


  void setCurftype(String value) {
    _curFtype = value;
    
  }

  void setCat(List<StmntCategory> value) {
    _cat = value;
    
  }
  
  void setCatType() {
    _incWorkingList.clear();
    _incAssetList.clear();
    _incOtherList.clear();
    _expInconsistList.clear();
    _expConsistList.clear();
    _savInvList.clear();
    _assLiquidList.clear();
    _assInvestList.clear();
    _assPrivateList.clear();
    _debtShortList.clear();
    _debtLongList.clear();
    _goalList.clear();
    for (var item in _cat) {
      if (item.ftype == '1') {
        _incWorkingList.add(item);
      } else if (item.ftype == '2') {
        _incAssetList.add(item);
      } else if (item.ftype == '3') {
        _incOtherList.add(item);
      } else if (item.ftype == '4') {
        _expInconsistList.add(item);
      } else if (item.ftype == '5') {
        _expConsistList.add(item);
      } else if (item.ftype == '6') {
        _savInvList.add(item);
      } else if (item.ftype == '7') {
        _assLiquidList.add(item);
      } else if (item.ftype == '8') {
        _assInvestList.add(item);
      } else if (item.ftype == '9') {
        _assPrivateList.add(item);
      } else if (item.ftype == '10') {
        _debtShortList.add(item);
      } else if (item.ftype == '11') {
        _debtLongList.add(item);
      } else if (item.ftype == '12') {
        _goalList.add(item);
      }
    }
    
    notifyListeners();
  }

  void setId(String value) {
    _id = value;
    notifyListeners();
  }
  void setName(String value) {
    _name = value;
    notifyListeners();
  }
  void setIcon(String value) {
    _icon = value;
    notifyListeners();
  }
  void setCurrCat(StmntCategory value) {
    _currCat = value;
    notifyListeners();
  }
  void setFtype(String value) {
    _ftype = value;
    notifyListeners();
  }
  

  void setNeedFetchAPI() {
    _needFetchAPI = !_needFetchAPI;
    notifyListeners();
  }

}