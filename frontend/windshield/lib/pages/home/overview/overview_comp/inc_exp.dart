import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:windshield/pages/home/home_page.dart';
import 'package:windshield/styles/theme.dart';

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
                Expense(),
              ],
            ),
          ),
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
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('รายรับเดือนนี้'),
            Text(
              '+${incWorking[0] + incAsset[0] + incOther[0]} บ.',
              style: const TextStyle(
                color: Color(0xff16D9AB),
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
                      Color(0xff14b6da),
                      Color(0xff2ae194),
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
                        percent: double.parse(
                                getPerc(incWorking, incAsset, incOther)) /
                            100,
                        animation: true,
                        animationDuration: 2000,
                        lineWidth: 6.5,
                        center: Text(
                          '${getPerc(incWorking, incAsset, incOther)}%',
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
                          Flexible(
                            flex: 1,
                            child: Text(
                              'เป้ารายรับที่เหลือ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: AutoSizeText(
                              '${leftAmount(incWorking, incAsset, incOther)} บ.',
                              maxLines: 1,
                              style: MyTheme.whiteTextTheme.headline3,
                            ),
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
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('รายจ่ายเดือนนี้'),
            Text(
              '-${expIncon[0] + expCon[0] + savInv[0]} บ.',
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
                        percent:
                            double.parse(getPerc(expIncon, expIncon, savInv)) /
                                100,
                        animation: true,
                        animationDuration: 2000,
                        lineWidth: 6.5,
                        center: Text(
                          '${getPerc(expIncon, expCon, savInv)}%',
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
                          Flexible(
                            flex: 1,
                            child: Text(
                              'เป้ารายจ่ายที่เหลือ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: AutoSizeText(
                              '${leftAmount(expIncon, expCon, savInv)} บ.',
                              maxLines: 1,
                              style: MyTheme.whiteTextTheme.headline4,
                            ),
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
    final perc = getLiqPerc(incWorking[0] + incAsset[0] + incOther[0], liquid);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff5236ff),
                Color(0xff75a1e3),
              ]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularPercentIndicator(
              radius: 35,
              progressColor: Colors.white,
              percent: double.parse(perc) / 100,
              animation: true,
              animationDuration: 2000,
              lineWidth: 10,
              center: Text('$perc%',
                  style: const TextStyle(
                    color: Colors.white,
                  )),
              backgroundColor: const Color(0x80ffffff),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'สภาพคล่องสุทธิปัจจุบัน',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  '$liquid บ.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
                // const Text(
                //   'เหลือใช้วันนี้ xx.xx บ.',
                //   style: TextStyle(
                //     color: Colors.white,
                //   ),
                // ),
              ],
            ),
          ],
        ),
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
      (incWorking[0] + incAsset[0] + incOther[0]);
  if (amount == 0) return '0';
  return amount <= -1 ? 'เกิน ${amount * -1}' : 'อีก $amount';
}

String getPerc(
  List<double> incWorking,
  List<double> incAsset,
  List<double> incOther,
) {
  final perc = (incWorking[0] + incAsset[0] + incOther[0]) /
      (incWorking[1] + incAsset[1] + incOther[1]) *
      100;
  return perc >= 100 ? '100' : perc.toStringAsFixed(2);
}

String getLiqPerc(double income, double liquid) {
  final perc = liquid / income * 100;
  return perc >= 100 ? '100' : perc.toStringAsFixed(2);
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
