import 'package:flutter/material.dart';

import 'stat_model.dart';

class StatProvider extends ChangeNotifier {
  Stat _stat = Stat(
    netWorth: 0,
    netCashFlow: 0,
    survivalRatio: 0,
    wealthRatio: 0,
    basicLiquidRatio: 0,
    debtServiceRatio: 0,
    savingRatio: 0,
    investRatio: 0,
    financialHealth: 0,
  );
  Stat get stat => _stat;

  void setStat(Stat value) {
    _stat = value;
    notifyListeners();
  }
}
