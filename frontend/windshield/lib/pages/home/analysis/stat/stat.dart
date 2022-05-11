import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:windshield/main.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'stat_provider.dart';
import 'package:windshield/styles/theme.dart';

final provStat =
    ChangeNotifierProvider.autoDispose<StatProvider>((ref) => StatProvider());

final apiStat = FutureProvider.autoDispose<void>((ref) async {
  final data = await ref.read(apiProvider).analStat();
  ref.read(provStat).setStat(data);
});

class StatTab extends ConsumerWidget {
  const StatTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stat = ref.watch(provStat.select((e) => e.stat));
    final api = ref.watch(apiStat);
    return api.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (_) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'เกณฑ์การตัดสิน',
                style: MyTheme.textTheme.headline4!.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: MyTheme.positiveMajor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const Text('อยู่ในเกณฑ์ที่ ดี'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: MyTheme.assetPersonal[0],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const Text('อยู่ในเกณฑ์ที่ ปานกลาง'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: MyTheme.expenseConsist[0],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const Text('อยู่ในเกณฑ์ที่ พอใช้'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: MyTheme.negativeMajor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const Text('อยู่ในเกณฑ์ที่ แย่'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'ความมั่งคั่งในปัจจุบัน',
                style: MyTheme.textTheme.headline4!.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const CriteriaInfo(
                          title: 'ความมั่งคั่งสุทธิ',
                          equation: '1 + 1 != 2',
                          desc: 'afmgamkfgdfkmgbdfkmgkdfgmdfogmdfogodmgfdkogm',
                          good: 'มากกว่า 1.5 เท่า',
                          medium: '1 - 1.5 เท่า',
                          fair: '0.5 - 1 เท่า',
                          bad: 'น้อยกว่า 0.5 เท่า',
                        ),
                      ),
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: getCriteriaColor(stat.netWorth, 'netWorth'),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.commentDollar,
                              size: 50,
                              color: Colors.white,
                            ),
                            const Text(
                              'ความมั่งคั่งสุทธิ',
                              style: TextStyle(color: Colors.white),
                            ),
                            AutoSizeText(
                              stat.netWorth == null
                                  ? 'ข้อมูลไม่เพียงพอ'
                                  : '${HelperNumber.format(stat.netWorth!)} บ.',
                              style: MyTheme.whiteTextTheme.headline3,
                              minFontSize: 0,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const CriteriaInfo(
                          title: 'กระแสเงินสดสุทธิ',
                          equation: '1 + 1 != 2',
                          desc: 'afmgamkfgdfkmgbdfkmgkdfgmdfogmdfogodmgfdkogm',
                          good: 'มากกว่า 1 เท่า',
                          medium: '0.5 - 1 เท่า',
                          fair: '0.25 - 0.5 เท่า',
                          bad: 'น้อยกว่า 0.25 เท่า',
                        ),
                      ),
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color:
                              getCriteriaColor(stat.netCashFlow, 'netCashFlow'),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.moneyBillWave,
                              size: 50,
                              color: Colors.white,
                            ),
                            const Text(
                              'กระเเสเงินสดสุทธิ',
                              style: TextStyle(color: Colors.white),
                            ),
                            AutoSizeText(
                              stat.netCashFlow == null
                                  ? 'ข้อมูลไม่เพียงพอ'
                                  : '${HelperNumber.format(stat.netCashFlow!)} บ.',
                              style: MyTheme.whiteTextTheme.headline3,
                              minFontSize: 0,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const CriteriaInfo(
                          title: 'อัตราส่วนความมั่งคั่ง',
                          equation: '1 + 1 != 2',
                          desc: 'afmgamkfgdfkmgbdfkmgkdfgmdfogmdfogodmgfdkogm',
                          good: 'มากกว่า 1.5 เท่า',
                          medium: '1 - 1.5 เท่า',
                          fair: '0.8 - 1 เท่า',
                          bad: 'น้อยกว่า 0.8',
                        ),
                      ),
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color:
                              getCriteriaColor(stat.wealthRatio, 'wealthRatio'),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.balanceScale,
                              size: 40,
                              color: Colors.white,
                            ),
                            const Text(
                              'อัตราส่วนความมั่งคั่ง',
                              style: TextStyle(color: Colors.white),
                            ),
                            AutoSizeText(
                              stat.wealthRatio == null
                                  ? 'ข้อมูลไม่เพียงพอ'
                                  : '${HelperNumber.format(stat.wealthRatio!)} บ.',
                              style: MyTheme.whiteTextTheme.headline3,
                              minFontSize: 0,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const CriteriaInfo(
                          title: 'อัตราส่วนความอยู่รอด',
                          equation: '1 + 1 != 2',
                          desc: 'afmgamkfgdfkmgbdfkmgkdfgmdfogmdfogodmgfdkogm',
                          good: 'มากกว่า 1.5 เท่า',
                          medium: '1 - 1.5 เท่า',
                          fair: '0.7 - 1 เท่า',
                          bad: 'น้อยกว่า 0.7 เท่า',
                        ),
                      ),
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: getCriteriaColor(
                              stat.survivalRatio, 'survivalRatio'),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.dizzy,
                              size: 40,
                              color: Colors.white,
                            ),
                            const Text(
                              'อัตราส่วนความอยู่รอด',
                              style: TextStyle(color: Colors.white),
                            ),
                            AutoSizeText(
                              stat.survivalRatio == null
                                  ? 'ข้อมูลไม่เพียงพอ'
                                  : '${HelperNumber.format(stat.survivalRatio!)} บ.',
                              style: MyTheme.whiteTextTheme.headline3,
                              minFontSize: 0,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'สภาพคล่องเเละ\nความสามารถในการชำระหนี้',
                style: MyTheme.textTheme.headline4!.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const CriteriaInfo(
                          title: 'อัตราส่วนสภาพคล่องพื้นฐาน',
                          equation: '1 + 1 != 2',
                          desc: 'afmgamkfgdfkmgbdfkmgkdfgmdfogmdfogodmgfdkogm',
                          good: 'มากกว่า 1.5 เท่า',
                          medium: '1 - 1.5 เท่า',
                          fair: '0.7 - 1 เท่า',
                          bad: 'น้อยกว่า 0.7 เท่า',
                        ),
                      ),
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: getCriteriaColor(
                              stat.basicLiquidRatio, 'basicLiquidRatio'),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.coins,
                              size: 50,
                              color: Colors.white,
                            ),
                            const Text(
                              'อัตราส่วน\nสภาพคล่องพื้นฐาน',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            AutoSizeText(
                              stat.basicLiquidRatio == null
                                  ? 'ข้อมูลไม่เพียงพอ'
                                  : '${HelperNumber.format(stat.basicLiquidRatio!)} บ.',
                              style: MyTheme.whiteTextTheme.headline3,
                              minFontSize: 0,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const CriteriaInfo(
                          title: 'อัตราส่วนการชำระหนี้สินจากสินทรัพย์',
                          equation: '1 + 1 != 2',
                          desc: 'afmgamkfgdfkmgbdfkmgkdfgmdfogmdfogodmgfdkogm',
                          good: 'น้อยกว่า 0.36 เท่า',
                          medium: '0.36 - 0.42 เท่า',
                          fair: '0.42 - 0.49 เท่า',
                          bad: 'มากกว่า 0.49 เท่า',
                        ),
                      ),
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: getCriteriaColor(
                              stat.debtServiceRatio, 'debtServiceRatio'),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.handHoldingUsd,
                              size: 50,
                              color: Colors.white,
                            ),
                            const Text(
                              'อัตราส่วนการชำระ\nหนี้สินจากรายได้',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            AutoSizeText(
                              stat.debtServiceRatio == null
                                  ? 'ข้อมูลไม่เพียงพอ'
                                  : '${HelperNumber.format(stat.debtServiceRatio!)} บ.',
                              style: MyTheme.whiteTextTheme.headline3,
                              minFontSize: 0,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'โอกาสในการสร้างความมั่งคั่ง',
                style: MyTheme.textTheme.headline4!.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const CriteriaInfo(
                          title: 'อัตราส่วนการออม',
                          equation: '1 + 1 != 2',
                          desc: 'afmgamkfgdfkmgbdfkmgkdfgmdfogmdfogodmgfdkogm',
                          good: 'มากกว่า 0.1 เท่า',
                          medium: '0.05 - 0.1 เท่า',
                          fair: '0.02 - 0.05 เท่า',
                          bad: 'น้อยกว่า 0.02 เท่า',
                        ),
                      ),
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color:
                              getCriteriaColor(stat.savingRatio, 'savingRatio'),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.piggyBank,
                              size: 40,
                              color: Colors.white,
                            ),
                            const Text(
                              'อัตราส่วนการออม',
                              style: TextStyle(color: Colors.white),
                            ),
                            AutoSizeText(
                              stat.savingRatio == null
                                  ? 'ข้อมูลไม่เพียงพอ'
                                  : '${HelperNumber.format(stat.savingRatio!)} บ.',
                              style: MyTheme.whiteTextTheme.headline3,
                              minFontSize: 0,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const CriteriaInfo(
                          title: 'อัตราส่วนการลงทุน',
                          equation: '1 + 1 != 2',
                          desc: 'afmgamkfgdfkmgbdfkmgkdfgmdfogmdfogodmgfdkogm',
                          good: '0 - 0.25 เท่า',
                          medium: '0.25 - 0.5 เท่า',
                          fair: '0.5 - 0.75 เท่า',
                          bad: 'มากกว่า 0.75 เท่า',
                        ),
                      ),
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color:
                              getCriteriaColor(stat.investRatio, 'investRatio'),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.chartLine,
                              size: 40,
                              color: Colors.white,
                            ),
                            const Text(
                              'อัตราส่วนการลงทุน',
                              style: TextStyle(color: Colors.white),
                            ),
                            AutoSizeText(
                              stat.investRatio == null
                                  ? 'ข้อมูลไม่เพียงพอ'
                                  : '${HelperNumber.format(stat.investRatio!)} บ.',
                              style: MyTheme.whiteTextTheme.headline3,
                              minFontSize: 0,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Color getCriteriaColor(double? value, String type) {
    if (value != null) {
      if (type.contains('netWorth')) {
        if (value > 1.5) return MyTheme.positiveMajor;
        if (value <= 1.5 && value > 1) return MyTheme.assetPersonal[0];
        if (value <= 1 && value > 0.5) return MyTheme.expenseConsist[0];
        return MyTheme.negativeMajor;
      }
      if (type.contains('netCashFlow')) {
        if (value > 1) return MyTheme.positiveMajor;
        if (value <= 1 && value > 0.5) return MyTheme.assetPersonal[0];
        if (value <= 0.5 && value > 0.25) return MyTheme.expenseConsist[0];
        return MyTheme.negativeMajor;
      }
      if (type.contains('wealthRatio')) {
        // มากกว่า 1.5 ดีมาก/ 1- 1.5 ดี / 0.8-1 พอใช้ / 0.8 ลงไป แย่
        if (value > 1.5) return MyTheme.positiveMajor;
        if (value <= 1.5 && value > 1) return MyTheme.assetPersonal[0];
        if (value <= 1 && value > 0.8) return MyTheme.expenseConsist[0];
        return MyTheme.negativeMajor;
      }
      if (type.contains('survivalRatio')) {
        // 1.5 ขึ้นไป ดีมาก / 1-1.5 ดี/ 0.7 - 1 แย่ / น้อยกว่า 0.7 แย่มาก
        if (value > 1.5) return MyTheme.positiveMajor;
        if (value <= 1.5 && value > 1) return MyTheme.assetPersonal[0];
        if (value <= 1 && value > 0.7) return MyTheme.expenseConsist[0];
        return MyTheme.negativeMajor;
      }
      if (type.contains('basicLiquidRatio')) {
        // 1.5 ขึ้นไป ดีมาก / 1-1.5 ดี/ 0.7 - 1 แย่ / น้อยกว่า 0.7 แย่มาก
        if (value > 1.5) return MyTheme.positiveMajor;
        if (value <= 1.5 && value > 1) return MyTheme.assetPersonal[0];
        if (value <= 1 && value >= 0.7) return MyTheme.expenseConsist[0];
        return MyTheme.negativeMajor;
      }
      if (type.contains('debtServiceRatio')) {
        // น้อยกว่า 36 ดีมาก / 37-42 ดี / 43 -49 เริ่มแย่ / 50 อันตราย
        if (value < 0.36) return MyTheme.positiveMajor;
        if (value < 0.42 && value >= 0.36) return MyTheme.assetPersonal[0];
        if (value < 0.49 && value >= 0.42) return MyTheme.expenseConsist[0];
        return MyTheme.negativeMajor;
      }
      if (type.contains('savingRatio')) {
        // <2 แย่ / 2-5 พอใช้ / 5-10 ปานกลาง / > 10 ดี
        if (value > 0.1) return MyTheme.positiveMajor;
        if (value <= 0.1 && value > 0.05) return MyTheme.assetPersonal[0];
        if (value <= 0.05 && value > 0.02) return MyTheme.expenseConsist[0];
        return MyTheme.negativeMajor;
      }
      if (type.contains('investRatio')) {
        // >=75 แย่ / >=50 พอใช้ / >=25 ปานกลาง / >=0 ดี
        if (value >= 0 && value < 0.25) return MyTheme.positiveMajor;
        if (value >= 0.25 && value < 0.50) return MyTheme.assetPersonal[0];
        if (value >= 0.50 && value < 0.75) return MyTheme.expenseConsist[0];
        return MyTheme.negativeMajor;
      }
    }
    return Colors.grey;
  }
}

class CriteriaInfo extends StatelessWidget {
  const CriteriaInfo({
    required this.title,
    required this.equation,
    required this.desc,
    required this.good,
    required this.medium,
    required this.fair,
    required this.bad,
    Key? key,
  }) : super(key: key);

  final String title;
  final String equation;
  final String desc;
  final String good;
  final String medium;
  final String fair;
  final String bad;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: MyTheme.textTheme.headline3,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 70,
            // width: double.infinity,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyTheme.primaryMinor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                equation,
                style: MyTheme.textTheme.bodyText2!.merge(
                  TextStyle(color: MyTheme.primaryMajor),
                ),
              ),
            ),
          ),
          Text(
            desc,
            style: MyTheme.textTheme.headline4,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: MyTheme.positiveMajor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Text(
                      good,
                      style: MyTheme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: MyTheme.assetPersonal[0],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Text(
                      medium,
                      style: MyTheme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: MyTheme.expenseConsist[0],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Text(
                      fair,
                      style: MyTheme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: MyTheme.negativeMajor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Text(
                      bad,
                      style: MyTheme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // titleTextStyle: TextStyle(fontSize: 5),
    );
  }
}
