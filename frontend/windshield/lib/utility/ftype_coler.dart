import 'package:flutter/material.dart';
import 'package:windshield/styles/theme.dart';

class HelperColor {
  static Map<String, Color> colors100 = <String, Color>{
    '1': MyTheme.incomeWorking[0],
    '2': MyTheme.incomeAsset[0],
    '3': MyTheme.incomeOther[0],
    '4': MyTheme.expenseInconsist[0],
    '5': MyTheme.expenseConsist[0],
    '6': MyTheme.savingAndInvest[0],
    '7': MyTheme.assetLiquid[0],
    '8': MyTheme.assetInvest[0],
    '9': MyTheme.assetPersonal[0],
    '10': MyTheme.debtShort[0],
    '11': MyTheme.debtLong[0],
    '12': MyTheme.savingAndInvest[0],
  };

  static Map<String, Color> colors50 = <String, Color>{
    '1': MyTheme.incomeWorking[1],
    '2': MyTheme.incomeAsset[1],
    '3': MyTheme.incomeOther[1],
    '4': MyTheme.expenseInconsist[1],
    '5': MyTheme.expenseConsist[1],
    '6': MyTheme.savingAndInvest[1],
    '7': MyTheme.assetLiquid[1],
    '8': MyTheme.assetInvest[1],
    '9': MyTheme.assetPersonal[1],
    '10': MyTheme.debtShort[1],
    '11': MyTheme.debtLong[1],
    '12': MyTheme.savingAndInvest[1],
  };

  static Color getFtColor(String ftype, int opacity) {
    if (opacity == 50) {
      return colors50[ftype] ?? Colors.white;
    }
    return colors100[ftype] ?? Colors.white;
  }
}
