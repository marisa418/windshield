import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/balance_sheet/balance_sheet.dart';
import 'package:windshield/pages/home/overview/balance_sheet/create_balance.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'create_balance.dart';

final apiBSheet = FutureProvider.autoDispose<BSheetBalance?>((ref) async {
  ref.watch(provBSheet.select((value) => value.needFetchAPI));

  final data = await ref.read(apiProvider).getBalanceSheet();
  final data2 = await ref.read(apiProvider).getAllCategories(false);
  final datalog = await ref.read(apiProvider).getBalanceSheetLog();
  ref.read(provBSheet).setBs(data!);
  ref.read(provBSheet).setCat(data2);
  ref.read(provBSheet).setLog(datalog);
  ref.read(provBSheet).setBsType();
  ref.read(provBSheet).setCatType();
  return data;
});

class BalanceSheetPage extends ConsumerWidget {
  const BalanceSheetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ของจริง apiBsheet
    final api = ref.watch(apiBSheet);
    //final api = ref.watch(apiDFlow);

    return api.when(
      error: (error, stackTrace) => Text(stackTrace.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (_) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                const AssetHomepage(),
                //แสดง widget หนี้สิน กับ ทรัพย์สิน

                //แสดงผล widget ส่วนล่าง
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Assettable(),
                            SizedBox(width: 15),
                            Depttable(),
                          ],
                        ),
                      ),
                      if (ref.watch(provBSheet.select((e) => e.pageIdx)) ==
                          0) ...const [
                        //asset page
                        LiqAssetTab(),
                        InvestAssetTab(),
                        PrivateAssetTab(),
                      ]
                      //debt page
                      else ...const [
                        DebtShortTab(),
                        DebtLongTab(),
                      ]
                    ],
                  ),
                ),

                //ปุ่มย้อนกลับ
                SizedBox(
                  height: 75,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      label: Text(
                        'ย้อนกลับ  ',
                        style: MyTheme.whiteTextTheme.headline3,
                      ),
                      icon: const Icon(
                        Icons.arrow_left,
                        color: Colors.white,
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: MyTheme.primaryMajor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () => AutoRouter.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AssetHomepage extends ConsumerWidget {
  const AssetHomepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baltotal = ref.watch(provBSheet.select((e) => e.balTotal));
    final log = ref.watch(provBSheet.select((e) => e.log));
    //double assetToal= baltotal*2;

    return Container(
      height: 190,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: MyTheme.majorBackground,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'งบดุลการเงินของคุณ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  decoration: TextDecoration.none,
                ),
              ),
              Wrap(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white),
                  Text(
                    DateFormat(' E d MMM y').format(DateTime.now()),
                    style: MyTheme.whiteTextTheme.headline4,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //วันที่
                    'ความมั่งคั่งสุทธิ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                      decoration: TextDecoration.none,
                      //Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Text(
                    '${HelperNumber.format(baltotal)} บ.',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        decoration: TextDecoration.none
                        //Theme.of(context).textTheme.bodyText1,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Icon(
                  //   Icons.date_range,
                  //   size: 24.0,
                  //   color: MyTheme.secondaryMinor,
                  // ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'ข้อมูลล่าสุด',
                        style: MyTheme.whiteTextTheme.bodyText2!.merge(
                          TextStyle(color: Colors.white.withOpacity(.5)),
                        ),
                      ),
                      Text(
                        //แก้วันที่ตรงนี้
                        DateFormat('d MMM y').format(log.timestamp),
                        style: MyTheme.whiteTextTheme.bodyText1,
                      ),
                    ],
                  ),
                  // Icon(
                  //   Icons.arrow_right,
                  //   size: 40.0,
                  //   color: MyTheme.secondaryMinor,
                  // ),
                ],
              )
            ],
          ),
        ],
      ),
      //Text('\n\nงบดุลของคุณ \n วันที่ 4 มีนาคม 2565 \n xxxxx บ.',style: MyTheme.whiteTextTheme.headline3),
    );
  }
}

class Assettable extends ConsumerWidget {
  const Assettable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assTotal = ref.watch(provBSheet.select((e) => e.assTotal));

    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(provBSheet).setPageIdx(0),
        child: Container(
          height: 75, //ขนาดกรอบ asset
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: MyTheme.assetBackground,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularPercentIndicator(
                radius: 25,
                progressColor: Colors.white,
                percent: 1,
                animation: true,
                animationDuration: 2000,
                lineWidth: 6.5,
                center: const Text(
                  'xx.x%',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                backgroundColor: const Color(0x80ffffff),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'สินทรัพย์',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '${HelperNumber.format(assTotal)} บ.',
                    style: MyTheme.whiteTextTheme.headline4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//depttable
class Depttable extends ConsumerWidget {
  const Depttable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtTotal = ref.watch(provBSheet.select((e) => e.debtTotal));

    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(provBSheet).setPageIdx(1),
        child: Container(
          height: 75, //ขนาดกรอบ asset
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: MyTheme.debtBackground,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularPercentIndicator(
                radius: 25,
                progressColor: Colors.white,
                percent: 0.744,
                animation: true,
                animationDuration: 2000,
                lineWidth: 6.5,
                center: const Text(
                  'xx.x%',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                backgroundColor: const Color(0x80ffffff),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'หนี้สิน',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '${HelperNumber.format(debtTotal)} บ.',
                    style: MyTheme.whiteTextTheme.headline4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiqAssetTab extends ConsumerWidget {
  const LiqAssetTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assLiquidList = ref.watch(provBSheet.select((e) => e.assLiquidList));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'สินทรัพย์สภาพคล่อง',
              style: MyTheme.textTheme.headline3,
            ),
          ),
          SizedBox(
            height: 130, //ขนาดแถว asset
            child: ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: assLiquidList.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return SizedBox(
                    height: 100,
                    width: 90,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 75, //height of button
                          width: 75, //width of button
                          child: ElevatedButton(
                            onPressed: () {
                              final cat = ref.watch(
                                  provBSheet.select((e) => e.catAssLiquidList));
                              ref.read(provBSheet).setValue(0);
                              ref.read(provBSheet).setSource('');
                              ref.read(provBSheet).setCreateCatList(cat);
                              ref.read(provBSheet).setCreateIdx(0);
                              ref.read(provBSheet).setIsAdd(true);
                              showModalBottomSheet(
                                //useRootNavigator: true,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (_) {
                                  return const CreateBalance();
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              shadowColor:
                                  Colors.transparent, //remove shadow on button
                              primary: MyTheme.primaryMinor,
                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: MyTheme.primaryMajor,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          'เพิ่มรายการใหม่',
                          minFontSize: 0,
                          maxLines: 1,
                          style: TextStyle(color: MyTheme.primaryMajor),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    width: 90, //ระยะห่างระหว่างสินทรัพย์
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width:
                                  100, //width of button แก้จำนวนเงิน overflow
                              child: ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(provBSheet)
                                      .setValue(assLiquidList[i - 1].recentVal);
                                  ref
                                      .read(provBSheet)
                                      .setSource(assLiquidList[i - 1].source);
                                  ref
                                      .read(provBSheet)
                                      .setId(assLiquidList[i - 1].id);
                                  ref
                                      .read(provBSheet)
                                      .setCurrCat(assLiquidList[i - 1].cat);
                                  ref.read(provBSheet).setCreateIdx(1);
                                  ref.read(provBSheet).setIsAdd(false);
                                  showModalBottomSheet(
                                    //useRootNavigator: true,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (_) {
                                      return const CreateBalance();
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: MyTheme.assetLiquid[0],
                                  shape: const CircleBorder(),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      HelperIcons.getIconData(
                                          assLiquidList[i - 1].cat.icon),
                                      color: Colors.white,
                                    ),
                                    AutoSizeText(
                                      HelperNumber.format(
                                        assLiquidList[i - 1].recentVal,
                                      ),
                                      minFontSize: 0,
                                      maxLines: 1,
                                      style: MyTheme.whiteTextTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        AutoSizeText(
                          assLiquidList[i - 1].cat.name,
                          minFontSize: 0,
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          assLiquidList[i - 1].source == ''
                              ? ""
                              : assLiquidList[i - 1].source,
                          style: MyTheme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InvestAssetTab extends ConsumerWidget {
  const InvestAssetTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assInvestList = ref.watch(provBSheet.select((e) => e.assInvestList));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'สินทรัพย์ลงทุน',
              style: MyTheme.textTheme.headline3,
            ),
          ),
          SizedBox(
            height: 130, //ขนาดแถว asset
            child: ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: assInvestList.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return SizedBox(
                    height: 100,
                    width: 90,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 75, //height of button
                          width: 75, //width of button
                          child: ElevatedButton(
                            onPressed: () {
                              final cat = ref.watch(
                                  provBSheet.select((e) => e.catAssInvestList));
                              ref.read(provBSheet).setValue(0);
                              ref.read(provBSheet).setSource('');
                              ref.read(provBSheet).setCreateCatList(cat);
                              ref.read(provBSheet).setCreateIdx(0);
                              ref.read(provBSheet).setIsAdd(true);
                              showModalBottomSheet(
                                  //useRootNavigator: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) {
                                    return const CreateBalance();
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              shadowColor:
                                  Colors.transparent, //remove shadow on button
                              primary: MyTheme.primaryMinor,
                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: MyTheme.primaryMajor,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          'เพิ่มรายการใหม่',
                          minFontSize: 0,
                          maxLines: 1,
                          style: TextStyle(color: MyTheme.primaryMajor),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    width: 90, //ระยะห่างระหว่างสินทรัพย์
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width:
                                  100, //width of button แก้จำนวนเงิน overflow
                              child: ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(provBSheet)
                                      .setValue(assInvestList[i - 1].recentVal);
                                  ref
                                      .read(provBSheet)
                                      .setSource(assInvestList[i - 1].source);
                                  ref
                                      .read(provBSheet)
                                      .setId(assInvestList[i - 1].id);
                                  ref
                                      .read(provBSheet)
                                      .setCurrCat(assInvestList[i - 1].cat);
                                  ref.read(provBSheet).setCreateIdx(1);
                                  ref.read(provBSheet).setIsAdd(false);
                                  showModalBottomSheet(
                                      //useRootNavigator: true,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (_) {
                                        return const CreateBalance();
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: MyTheme.assetLiquid[0],
                                  shape: const CircleBorder(),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      HelperIcons.getIconData(
                                          assInvestList[i - 1].cat.icon),
                                      color: Colors.white,
                                    ),
                                    AutoSizeText(
                                      HelperNumber.format(
                                        assInvestList[i - 1].recentVal,
                                      ),
                                      minFontSize: 0,
                                      maxLines: 1,
                                      style: MyTheme.whiteTextTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        AutoSizeText(
                          assInvestList[i - 1].cat.name,
                          minFontSize: 0,
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          assInvestList[i - 1].source == ''
                              ? ""
                              : assInvestList[i - 1].source,
                          style: MyTheme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PrivateAssetTab extends ConsumerWidget {
  const PrivateAssetTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assPrivateList =
        ref.watch(provBSheet.select((e) => e.assPrivateList));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'สินทรัพย์สภาพคล่อง',
              style: MyTheme.textTheme.headline3,
            ),
          ),
          SizedBox(
            height: 130, //ขนาดแถว asset
            child: ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: assPrivateList.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return SizedBox(
                    height: 100,
                    width: 90,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 75, //height of button
                          width: 75, //width of button
                          child: ElevatedButton(
                            onPressed: () {
                              final cat = ref.watch(
                                  provBSheet.select((e) => e.catAssLiquidList));
                              ref.read(provBSheet).setValue(0);
                              ref.read(provBSheet).setSource('');
                              ref.read(provBSheet).setCreateCatList(cat);
                              ref.read(provBSheet).setCreateIdx(0);
                              ref.read(provBSheet).setIsAdd(true);
                              showModalBottomSheet(
                                //useRootNavigator: true,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (_) {
                                  return const CreateBalance();
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              shadowColor:
                                  Colors.transparent, //remove shadow on button
                              primary: MyTheme.primaryMinor,

                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: MyTheme.primaryMajor,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          'เพิ่มรายการใหม่',
                          minFontSize: 0,
                          maxLines: 1,
                          style: TextStyle(color: MyTheme.primaryMajor),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    width: 90, //ระยะห่างระหว่างสินทรัพย์
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width:
                                  100, //width of button แก้จำนวนเงิน overflow
                              child: ElevatedButton(
                                onPressed: () {
                                  ref.read(provBSheet).setValue(
                                      assPrivateList[i - 1].recentVal);
                                  ref
                                      .read(provBSheet)
                                      .setSource(assPrivateList[i - 1].source);
                                  ref
                                      .read(provBSheet)
                                      .setId(assPrivateList[i - 1].id);
                                  ref
                                      .read(provBSheet)
                                      .setCurrCat(assPrivateList[i - 1].cat);
                                  ref.read(provBSheet).setCreateIdx(1);
                                  ref.read(provBSheet).setIsAdd(false);
                                  showModalBottomSheet(
                                    //useRootNavigator: true,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (_) {
                                      return const CreateBalance();
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: MyTheme.assetLiquid[0],
                                  shape: const CircleBorder(),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      HelperIcons.getIconData(
                                          assPrivateList[i - 1].cat.icon),
                                      color: Colors.white,
                                    ),
                                    AutoSizeText(
                                      HelperNumber.format(
                                        assPrivateList[i - 1].recentVal,
                                      ),
                                      minFontSize: 0,
                                      maxLines: 1,
                                      style: MyTheme.whiteTextTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        AutoSizeText(
                          assPrivateList[i - 1].cat.name,
                          minFontSize: 0,
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          assPrivateList[i - 1].source == ''
                              ? ""
                              : assPrivateList[i - 1].source,
                          style: MyTheme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DebtShortTab extends ConsumerWidget {
  const DebtShortTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtShortList = ref.watch(provBSheet.select((e) => e.debtShortList));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'หนี้ระยะสั้น',
              style: MyTheme.textTheme.headline3,
            ),
          ),
          SizedBox(
            height: 130, //ขนาดแถว debt
            child: ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: debtShortList.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return SizedBox(
                    height: 100,
                    width: 90,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 75, //height of button
                          width: 75, //width of button
                          child: ElevatedButton(
                            //เพิ่มรายการใหม่
                            onPressed: () {
                              final cat = ref.watch(
                                  provBSheet.select((e) => e.catDebtShortList));
                              ref.read(provBSheet).setBalance(0);
                              ref.read(provBSheet).setCreditor('');
                              ref.read(provBSheet).setInterest(0);
                              ref.read(provBSheet).setDebtTerm(null);
                              ref.read(provBSheet).setCreateCatList(cat);
                              ref.read(provBSheet).setCreateIdx(0);
                              ref.read(provBSheet).setIsAdd(true);
                              showModalBottomSheet(
                                  //useRootNavigator: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) {
                                    return const CreateBalance();
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              shadowColor:
                                  Colors.transparent, //remove shadow on button
                              primary: MyTheme.primaryMinor,

                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: MyTheme.primaryMajor,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          'เพิ่มรายการใหม่',
                          minFontSize: 0,
                          maxLines: 1,
                          style: TextStyle(color: MyTheme.primaryMajor),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    width: 90, //ระยะห่างระหว่างสินทรัพย์
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 100, //width of button
                              child: ElevatedButton(
                                //แก้ไข
                                onPressed: () {
                                  ref
                                      .read(provBSheet)
                                      .setBalance(debtShortList[i - 1].balance);
                                  ref.read(provBSheet).setCreditor(
                                      debtShortList[i - 1].creditor);
                                  ref.read(provBSheet).setInterest(
                                      debtShortList[i - 1].interest);
                                  ref.read(provBSheet).setDebtTerm(
                                      debtShortList[i - 1].debtTerm);
                                  ref
                                      .read(provBSheet)
                                      .setCurrCat(debtShortList[i - 1].cat);
                                  ref.read(provBSheet).setCreateIdx(1);
                                  ref
                                      .read(provBSheet)
                                      .setId(debtShortList[i - 1].id);
                                  ref.read(provBSheet).setIsAdd(false);
                                  showModalBottomSheet(
                                      //useRootNavigator: true,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (_) {
                                        return const CreateBalance();
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: MyTheme.negativeMajor,
                                  shape: const CircleBorder(),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      HelperIcons.getIconData(
                                          debtShortList[i - 1].cat.icon),
                                      color: Colors.white,
                                    ),
                                    AutoSizeText(
                                      HelperNumber.format(
                                        debtShortList[i - 1].balance,
                                      ),
                                      minFontSize: 0,
                                      maxLines: 1,
                                      style: MyTheme.whiteTextTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        AutoSizeText(
                          debtShortList[i - 1].cat.name,
                          minFontSize: 0,
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          debtShortList[i - 1].creditor == ''
                              ? ""
                              : debtShortList[i - 1].creditor,
                          style: MyTheme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DebtLongTab extends ConsumerWidget {
  const DebtLongTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtLongList = ref.watch(provBSheet.select((e) => e.debtLongList));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'หนี้ระยะยาว',
              style: MyTheme.textTheme.headline3,
            ),
          ),
          SizedBox(
            height: 130, //ขนาดแถว debt
            child: ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: debtLongList.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return SizedBox(
                    height: 100,
                    width: 90,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 75, //height of button
                          width: 75, //width of button
                          child: ElevatedButton(
                            //เพิ่มรายการใหม่
                            onPressed: () {
                              final cat = ref.watch(
                                  provBSheet.select((e) => e.catDebtShortList));
                              ref.read(provBSheet).setBalance(0);
                              ref.read(provBSheet).setCreditor('');
                              ref.read(provBSheet).setInterest(0);
                              ref.read(provBSheet).setDebtTerm(null);
                              ref.read(provBSheet).setCreateCatList(cat);
                              ref.read(provBSheet).setCreateIdx(0);
                              ref.read(provBSheet).setIsAdd(true);
                              showModalBottomSheet(
                                  //useRootNavigator: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) {
                                    return const CreateBalance();
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              shadowColor:
                                  Colors.transparent, //remove shadow on button
                              primary: MyTheme.primaryMinor,

                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: MyTheme.primaryMajor,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          'เพิ่มรายการใหม่',
                          minFontSize: 0,
                          maxLines: 1,
                          style: TextStyle(color: MyTheme.primaryMajor),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    width: 90, //ระยะห่างระหว่างสินทรัพย์
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 100, //width of button
                              child: ElevatedButton(
                                //แก้ไข
                                onPressed: () {
                                  ref
                                      .read(provBSheet)
                                      .setBalance(debtLongList[i - 1].balance);
                                  ref.read(provBSheet).setCreditor(
                                      debtLongList[i - 1].creditor);
                                  ref.read(provBSheet).setInterest(
                                      debtLongList[i - 1].interest);
                                  ref.read(provBSheet).setDebtTerm(
                                      debtLongList[i - 1].debtTerm);
                                  ref
                                      .read(provBSheet)
                                      .setCurrCat(debtLongList[i - 1].cat);
                                  ref.read(provBSheet).setCreateIdx(1);
                                  ref
                                      .read(provBSheet)
                                      .setId(debtLongList[i - 1].id);
                                  ref.read(provBSheet).setIsAdd(false);
                                  showModalBottomSheet(
                                      //useRootNavigator: true,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (_) {
                                        return const CreateBalance();
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: MyTheme.negativeMajor,
                                  shape: const CircleBorder(),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      HelperIcons.getIconData(
                                          debtLongList[i - 1].cat.icon),
                                      color: Colors.white,
                                    ),
                                    AutoSizeText(
                                      HelperNumber.format(
                                        debtLongList[i - 1].balance,
                                      ),
                                      minFontSize: 0,
                                      maxLines: 1,
                                      style: MyTheme.whiteTextTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        AutoSizeText(
                          debtLongList[i - 1].cat.name,
                          minFontSize: 0,
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          debtLongList[i - 1].creditor == ''
                              ? ""
                              : debtLongList[i - 1].creditor,
                          style: MyTheme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
