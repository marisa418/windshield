import 'package:flutter/material.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/number_formatter.dart';

double getFlowsProg(double flow, double budget) {
  if (budget == 0) return 0;
  if (flow >= budget) return budget;
  return flow;
}

String leftAmount(
  List<double> incWorking,
  List<double> incAsset,
  List<double> incOther,
) {
  final amount = (incWorking[1] + incAsset[1] + incOther[1]) -
      (getFlowsProg(incWorking[0], incWorking[1]) +
          getFlowsProg(incAsset[0], incAsset[1]) +
          getFlowsProg(incOther[0], incOther[1]));
  final amountStr = HelperNumber.format(amount <= -1 ? amount * -1 : amount);
  return amount <= 0 ? 'ครบเป้า' : 'อีก $amountStr บ.';
}

String leftAmountBudget(
  double incWorking,
  double incWorkingBud,
  double incAsset,
  double incAssetBud,
  double incOther,
  double incOtherBud,
) {
  final amount = (incWorkingBud + incAssetBud + incOtherBud) -
      (getFlowsProg(incWorking, incWorkingBud) +
          getFlowsProg(incAsset, incAssetBud) +
          getFlowsProg(incOther, incOtherBud));
  final amountStr = HelperNumber.format(amount <= -1 ? amount * -1 : amount);
  return amount <= 0 ? 'ครบเป้า' : 'อีก $amountStr บ.';
}

Text total(
  List<double> incWorking,
  List<double> incAsset,
  List<double> incOther,
  List<double> expIncon,
  List<double> expCon,
  List<double> savInv,
) {
  final amount = (incWorking[0] +
          incWorking[1] +
          incAsset[0] +
          incAsset[1] +
          incOther[0] +
          incOther[1]) -
      (expIncon[0] +
          expIncon[1] +
          expCon[0] +
          expCon[1] +
          savInv[0] +
          savInv[1]);
  if (amount > 0) {
    return Text(
      '+${HelperNumber.format(amount)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.positiveMajor,
        ),
      ),
    );
  } else if (amount < 0) {
    return Text(
      '${HelperNumber.format(amount)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.negativeMajor,
        ),
      ),
    );
  } else {
    return Text(
      '${HelperNumber.format(amount)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.positiveMajor,
        ),
      ),
    );
  }
}

Text totalWithBudget(
  double incWorking,
  double incWorkingBud,
  double incAsset,
  double incAssetBud,
  double incOther,
  double incOtherBud,
  double expIncon,
  double expInconBud,
  double expCon,
  double expConBud,
  double savInv,
  double savInvBud,
) {
  final amount = (incWorking +
          incWorkingBud +
          incAsset +
          incAssetBud +
          incOther +
          incOtherBud) -
      (expIncon + expInconBud + expCon + expConBud + savInv + savInvBud);
  if (amount > 0) {
    return Text(
      '+${HelperNumber.format(amount)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.positiveMajor,
        ),
      ),
    );
  } else if (amount < 0) {
    return Text(
      '${HelperNumber.format(amount)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.negativeMajor,
        ),
      ),
    );
  } else {
    return Text(
      '${HelperNumber.format(amount)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.positiveMajor,
        ),
      ),
    );
  }
}
