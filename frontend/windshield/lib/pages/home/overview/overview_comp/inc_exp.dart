import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';

import '../overview_page.dart';

class IncExp extends ConsumerWidget {
  const IncExp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 270,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 55,
            child: Row(
              children: const [
                Income(),
                SizedBox(width: 15),
                Expense(),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Flexible(
            flex: 45,
            child: Liquidity(),
          ),
        ],
      ),
    );
  }
}

class Income extends ConsumerWidget {
  const Income({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorking = ref.watch(provHome.select((e) => e.incWorking));
    final incAsset = ref.watch(provHome.select((e) => e.incAsset));
    final incOther = ref.watch(provHome.select((e) => e.incOther));
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('รายรับเดือนนี้'),
          Text(
            '+${HelperNumber.format(incWorking[0] + incAsset[0] + incOther[0])} บ.',
            style: const TextStyle(
              color: Color(0xff16D9AB),
              fontSize: 24,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: MyTheme.incomeBackground,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 4,
                    child: CircularPercentIndicator(
                      radius: 25,
                      progressColor: Colors.white,
                      // percent: double.parse(
                      //         getPerc(incWorking, incAsset, incOther)) /
                      //     100,
                      percent: HelperProgress.getPercent(
                        getFlowsProg(incWorking[0], incWorking[1]) +
                            getFlowsProg(incAsset[0], incAsset[1]) +
                            getFlowsProg(incOther[0], incOther[1]),
                        (incWorking[1] + incAsset[1] + incOther[1]),
                      ),
                      animation: true,
                      animationDuration: 2000,
                      lineWidth: 6.5,
                      center: Text(
                        '${HelperNumber.format(HelperProgress.getPercent(
                              getFlowsProg(incWorking[0], incWorking[1]) +
                                  getFlowsProg(incAsset[0], incAsset[1]) +
                                  getFlowsProg(incOther[0], incOther[1]),
                              (incWorking[1] + incAsset[1] + incOther[1]),
                            ) * 100)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      backgroundColor: const Color(0x80ffffff),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'เป้ารายรับที่เหลือ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10,
                          ),
                        ),
                        AutoSizeText(
                          leftAmount(incWorking, incAsset, incOther),
                          maxLines: 1,
                          style: MyTheme.whiteTextTheme.headline3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Expense extends ConsumerWidget {
  const Expense({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expIncon = ref.watch(provHome.select((e) => e.expIncon));
    final expCon = ref.watch(provHome.select((e) => e.expCon));
    final savInv = ref.watch(provHome.select((e) => e.savInv));
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('รายจ่ายเดือนนี้'),
          Text(
            '-${HelperNumber.format(expIncon[0] + expCon[0] + savInv[0])} บ.',
            style: const TextStyle(
              color: Color(0xffe3006d),
              fontSize: 24,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xffdf4833),
                    Color(0xffee3884),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 4,
                    child: CircularPercentIndicator(
                      radius: 25,
                      progressColor: Colors.white,
                      percent: HelperProgress.getPercent(
                        getFlowsProg(expIncon[0], expIncon[1]) +
                            getFlowsProg(expCon[0], expCon[1]) +
                            getFlowsProg(savInv[0], savInv[1]),
                        (expIncon[1] + expCon[1] + savInv[1]),
                      ),
                      animation: true,
                      animationDuration: 2000,
                      lineWidth: 6.5,
                      center: Text(
                        '${HelperNumber.format(HelperProgress.getPercent(
                              getFlowsProg(expIncon[0], expIncon[1]) +
                                  getFlowsProg(expCon[0], expCon[1]) +
                                  getFlowsProg(savInv[0], savInv[1]),
                              (expIncon[1] + expCon[1] + savInv[1]),
                            ) * 100)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      backgroundColor: const Color(0x80ffffff),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'เป้ารายจ่ายที่เหลือ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10,
                          ),
                        ),
                        AutoSizeText(
                          leftAmount(expIncon, expCon, savInv),
                          maxLines: 1,
                          style: MyTheme.whiteTextTheme.headline3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Liquidity extends ConsumerWidget {
  const Liquidity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorking = ref.watch(provHome.select((e) => e.incWorking));
    final incAsset = ref.watch(provHome.select((e) => e.incAsset));
    final incOther = ref.watch(provHome.select((e) => e.incOther));
    final expIncon = ref.watch(provHome.select((e) => e.expIncon));
    final expCon = ref.watch(provHome.select((e) => e.expCon));
    final savInv = ref.watch(provHome.select((e) => e.savInv));
    final liquid = (incWorking[0] + incAsset[0] + incOther[0]) -
        (expIncon[0] + expCon[0] + savInv[0]);
    final perc = HelperProgress.getPercent(
        liquid, incWorking[0] + incAsset[0] + incOther[0]);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: MyTheme.majorBackground,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularPercentIndicator(
            radius: 35,
            progressColor: Colors.white,
            percent: perc,
            animation: true,
            animationDuration: 2000,
            lineWidth: 10,
            center: Text('${HelperNumber.format(perc * 100)}%',
                style: const TextStyle(
                  color: Colors.white,
                )),
            backgroundColor: const Color(0x80ffffff),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'สภาพคล่องสุทธิปัจจุบัน',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                AutoSizeText(
                  '${HelperNumber.format(liquid)} บ.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                  minFontSize: 0,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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

// String getPerc(
//   List<double> incWorking,
//   List<double> incAsset,
//   List<double> incOther,
// ) {
//   final perc = (incWorking[0] + incAsset[0] + incOther[0]) /
//       (incWorking[1] + incAsset[1] + incOther[1]) *
//       100;
//   return perc >= 100 ? '100' : perc.toStringAsFixed(2);
// }

// String getLiqPerc(double income, double liquid) {
//   final perc = liquid / income * 100;
//   return perc >= 100 ? '100' : perc.toStringAsFixed(2);
// }

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
      '+${amount.toStringAsFixed(2)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.positiveMajor,
        ),
      ),
    );
  } else if (amount < 0) {
    return Text(
      '${amount.toStringAsFixed(2)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.negativeMajor,
        ),
      ),
    );
  } else {
    return Text(
      '${amount.toStringAsFixed(0)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.positiveMajor,
        ),
      ),
    );
  }
}

double getFlowsProg(double flow, double budget) {
  if (budget == 0) return 0;
  if (flow >= budget) return budget;
  return flow;
}
