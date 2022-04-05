import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:windshield/main.dart';
import 'package:windshield/models/balance_sheet/balance_sheet.dart';
import 'package:windshield/models/daily_flow/flow.dart';
import 'package:windshield/pages/home/overview/balance_sheet/create_balance.dart';
import 'package:windshield/styles/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:badges/badges.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'create_balance.dart';

final apiBSheet = FutureProvider.autoDispose<BSheetBalance?>((ref) async {
  ref.watch(provBSheet.select((value) => value.needFetchAPI));
  final data = await ref.read(apiProvider).getBalanceSheet();
  final data2 = await ref.read(apiProvider).getAllCategories(false);
  ref.read(provBSheet).setBs(data!);
  ref.read(provBSheet).setCat(data2);
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
        return Scaffold(
          body: Column(
            children: [
              AssetHomepage(),

              //แสดง widget หนี้สิน กับ ทรัพย์สิน

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Assettable(),
                    Depttable(),
                  ],
                ),
              ),

              //แสดงผล widget ส่วนล่าง

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ref.watch(provBSheet.select((e) => e.pageIdx)) ==
                          0) ...[
                        //asset page
                        LiqAssetTab(),
                        InvestAssetTab(),
                        PrivateAssetTab(),
                      ]
                      //debt page
                      else ...[
                        DebtShortTab(),
                        DebtLongTab(),
                      ]
                    ],
                  ),
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
        );
      },
    );
  }
}

class AssetHomepage extends ConsumerWidget {
  const AssetHomepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final incTotal = ref.watch(provDFlow.select((e) => e.incTotal));
    final baltotal = ref.watch(provBSheet.select((e) => e.balTotal));
    //double assetToal= baltotal*2;

    var now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                  child: Text(
                    'งบดุลการเงินของคุณ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
            //วันปัจจุบัน
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                ),
                const Icon(Icons.calendar_today, color: Colors.white),
                Text(DateFormat(' E d MMM y').format(DateTime.now()),
                    style: MyTheme.whiteTextTheme.headline4),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 35.0, 0.0, 0.0),
              child: Text(
                //วันที่
                'ความมั่งคั่งสุทธิ',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 15,
                    decoration: TextDecoration.none
                    //Theme.of(context).textTheme.bodyText1,
                    ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 5.0, 0.0, 0.0),
                  child: Text(
                    '$baltotal',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        decoration: TextDecoration.none
                        //Theme.of(context).textTheme.bodyText1,
                        ),
                  ),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 20.0,
                        color: MyTheme.secondaryMinor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          //แก้วันที่ตรงนี้
                          'ข้อมูลล่าสุด\n',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: MyTheme.secondaryMinor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_right,
                        size: 40.0,
                        color: MyTheme.secondaryMinor,
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        //Text('\n\nงบดุลของคุณ \n วันที่ 4 มีนาคม 2565 \n xxxxx บ.',style: MyTheme.whiteTextTheme.headline3),

        height: 190,
        width: 500,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 82, 54, 255),
                Color.fromARGB(255, 117, 161, 227),
              ]),
          //borderRadius: BorderRadius.circular(10),
        ));
  }
}

class Assettable extends ConsumerWidget {
  const Assettable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assLiquidTotal =
        ref.watch(provBSheet.select((e) => e.assLiquidTotal));
    final assInvestTotal =
        ref.watch(provBSheet.select((e) => e.assInvestTotal));
    final assPrivateTotal =
        ref.watch(provBSheet.select((e) => e.assPrivateTotal));
    final assTotal = ref.watch(provBSheet.select((e) => e.assTotal));

    //double assetTotal = assLiquidTotal+assInvestTotal+assPrivateTotal;

    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(provBSheet).setPageIdx(),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromARGB(255, 52, 186, 216),
                  Color.fromARGB(255, 56, 91, 206),
                ]),
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
                center: const Text('xx.x%',
                    style: TextStyle(color: Colors.white, fontSize: 11)),
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
                    '$assTotal' + ' บ.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
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
        onTap: () => ref.read(provBSheet).setPageIdx(),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xffee3884),
                  Color(0xffab47bc),
                ]),
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
                center: Text('xx.x%',
                    style: TextStyle(color: Colors.white, fontSize: 11)),
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
                    '$debtTotal' + ' บ.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
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
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child:
                Text('สินทรัพย์สภาพคล่อง', style: MyTheme.textTheme.headline3),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              //padding: EdgeInsets.only(left:10),
              physics: const ScrollPhysics(),
              //shrinkWrap: true,
              itemCount: assLiquidList.length + 1,
              scrollDirection: Axis.horizontal,
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 4,
              //   mainAxisSpacing: 10,
              //   crossAxisSpacing: 10,
              //   mainAxisExtent: 100,
              // ),
              itemBuilder: (_, i) {
                if (i == 0) {
                  return SizedBox(
                    height: 100,
                    width: 80,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 75, //width of button
                              child: ElevatedButton(
                                onPressed: () {
                                  final cat = ref.watch(provBSheet.select((e) => e.catAssLiquidList));
                                  
                                  ref.read(provBSheet).setValue(0);
                                  ref.read(provBSheet).setSource('');
                                  ref
                                      .read(provBSheet)
                                      .setCreateCatList(cat);
                                  ref.read(provBSheet).setCreateIdx(0);
                                  ref.read(provBSheet).setIsAdd(true);
                                  showModalBottomSheet(
                                    //useRootNavigator: true,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (_){
                                      return CreateBalance();
                                      }
                                    );
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  shadowColor: Colors
                                      .transparent, //remove shadow on button
                                  primary: MyTheme.primaryMinor,

                                  padding: const EdgeInsets.all(10),

                                  shape: const CircleBorder(),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: MyTheme.primaryMajor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text('เพิ่มรายการใหม่'),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    width: 110,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 75, //width of button
                              child: ElevatedButton(
                                onPressed: () {
                                  ref.read(provBSheet).setValue(assLiquidList[i-1].recentVal);
                                  ref.read(provBSheet).setSource(assLiquidList[i-1].source);
                                  ref.read(provBSheet).setId(assLiquidList[i-1].id);
                                  ref.read(provBSheet).setCurrCat(assLiquidList[i-1].cat);
                                  ref.read(provBSheet).setCreateIdx(1);
                                  ref.read(provBSheet).setIsAdd(false);
                                  showModalBottomSheet(
                                    //useRootNavigator: true,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (_){
                                      return CreateBalance();
                                      }
                                    );
                                },
                                style: ElevatedButton.styleFrom(
                                  //elevation: 0.0,
                                  //shadowColor: Colors
                                  //    .transparent, //remove shadow on button
                                  primary: MyTheme.assetLiquid[0],
                                  textStyle: MyTheme.whiteTextTheme.headline4,
                                  padding: const EdgeInsets.all(10),

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
                                    Text(assLiquidList[i - 1]
                                        .recentVal
                                        .toString()),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(assLiquidList[i - 1].source)
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
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('สินทรัพย์ลงทุน', style: MyTheme.textTheme.headline3),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              //padding: EdgeInsets.only(left:10),
              physics: const ScrollPhysics(),
              //shrinkWrap: true,
              itemCount: assInvestList.length + 1,
              scrollDirection: Axis.horizontal,
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 4,
              //   mainAxisSpacing: 10,
              //   crossAxisSpacing: 10,
              //   mainAxisExtent: 100,
              // ),
              itemBuilder: (_, i) {
                if (i == 0) {
                  return SizedBox(
                    height: 100,
                    width: 80,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 75, //width of button
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  shadowColor: Colors
                                      .transparent, //remove shadow on button
                                  primary: MyTheme.primaryMinor,

                                  padding: const EdgeInsets.all(10),

                                  shape: const CircleBorder(),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: MyTheme.primaryMajor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text('เพิ่มรายการใหม่'),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    width: 110,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 75, //width of button
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  //elevation: 0.0,
                                  //shadowColor: Colors
                                  //    .transparent, //remove shadow on button
                                  primary: MyTheme.assetLiquid[0],
                                  textStyle: MyTheme.whiteTextTheme.headline4,
                                  padding: const EdgeInsets.all(10),

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
                                    Text(assInvestList[i - 1]
                                        .recentVal
                                        .toString()),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(assInvestList[i - 1].source)
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
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('สินทรัพย์ส่วนตัว', style: MyTheme.textTheme.headline3),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              //padding: EdgeInsets.only(left:10),
              physics: const ScrollPhysics(),
              //shrinkWrap: true,
              itemCount: assPrivateList.length + 1,
              scrollDirection: Axis.horizontal,
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 4,
              //   mainAxisSpacing: 10,
              //   crossAxisSpacing: 10,
              //   mainAxisExtent: 100,
              // ),
              itemBuilder: (_, i) {
                if (i == 0) {
                  return SizedBox(
                    height: 100,
                    width: 80,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 75, //width of button
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  shadowColor: Colors
                                      .transparent, //remove shadow on button
                                  primary: MyTheme.primaryMinor,

                                  padding: const EdgeInsets.all(10),

                                  shape: const CircleBorder(),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: MyTheme.primaryMajor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text('เพิ่มรายการใหม่'),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    width: 110,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 75, //width of button
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  //elevation: 0.0,
                                  //shadowColor: Colors
                                  //    .transparent, //remove shadow on button
                                  primary: MyTheme.assetLiquid[0],
                                  textStyle: MyTheme.whiteTextTheme.headline4,
                                  padding: const EdgeInsets.all(10),

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
                                    Text(assPrivateList[i - 1]
                                        .recentVal
                                        .toString()),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(assPrivateList[i - 1].source)
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
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('หนี้ระยะสั้น', style: MyTheme.textTheme.headline3),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              //padding: EdgeInsets.only(left:10),
              physics: const ScrollPhysics(),
              //shrinkWrap: true,
              itemCount: debtShortList.length + 1,
              scrollDirection: Axis.horizontal,
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 4,
              //   mainAxisSpacing: 10,
              //   crossAxisSpacing: 10,
              //   mainAxisExtent: 100,
              // ),
              itemBuilder: (_, i) {
                if (i == 0) {
                  return SizedBox(
                    height: 100,
                    width: 80,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 75, //width of button
                              child: ElevatedButton(
                                //เพิ่มรายการใหม่
                                onPressed: () {
                                  final cat = ref.watch(provBSheet.select((e) => e.catDebtShortList));
                                  
                                  ref.read(provBSheet).setBalance(0);
                                  ref.read(provBSheet).setCreditor('');
                                  ref.read(provBSheet).setInterest(0);
                                  ref.read(provBSheet).setDebtTerm(null);

                                  ref
                                      .read(provBSheet)
                                      .setCreateCatList(cat);
                                  ref.read(provBSheet).setCreateIdx(0);
                                  ref.read(provBSheet).setIsAdd(true);
                                  showModalBottomSheet(
                                    //useRootNavigator: true,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (_){
                                      return CreateBalance();
                                      }
                                    );
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  shadowColor: Colors
                                      .transparent, //remove shadow on button
                                  primary: MyTheme.primaryMinor,

                                  padding: const EdgeInsets.all(10),

                                  shape: const CircleBorder(),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: MyTheme.primaryMajor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text('เพิ่มรายการใหม่'),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    width: 110,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 75, //width of button
                              child: ElevatedButton(
                                //แก้ไข
                                onPressed: () {
                                  //final cat = ref.watch(provBSheet.select((e) => e.catDebtShortList));
                                  
                                  ref.read(provBSheet).setBalance(debtShortList[i-1].balance);
                                  ref.read(provBSheet).setCreditor(debtShortList[i-1].creditor);
                                  ref.read(provBSheet).setInterest(debtShortList[i-1].interest);
                                  ref.read(provBSheet).setDebtTerm(debtShortList[i-1].debtTerm);

                                  ref
                                      .read(provBSheet)
                                      .setCurrCat(debtShortList[i-1].cat);
                                  ref.read(provBSheet).setCreateIdx(1);
                                  ref.read(provBSheet).setId(debtShortList[i-1].id);
                                  ref.read(provBSheet).setIsAdd(false);
                                  showModalBottomSheet(
                                    //useRootNavigator: true,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (_){
                                      return CreateBalance();
                                      }
                                    );
                                },
                                style: ElevatedButton.styleFrom(
                                  //elevation: 0.0,
                                  //shadowColor: Colors
                                  //    .transparent, //remove shadow on button
                                  primary: MyTheme.negativeMajor,
                                  textStyle: MyTheme.whiteTextTheme.headline4,
                                  padding: const EdgeInsets.all(10),

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
                                    Text(debtShortList[i - 1]
                                        .balance
                                        .toString()),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(debtShortList[i - 1].creditor)
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
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('หนี้ระยะยาว', style: MyTheme.textTheme.headline3),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              //padding: EdgeInsets.only(left:10),
              physics: const ScrollPhysics(),
              //shrinkWrap: true,
              itemCount: debtLongList.length + 1,
              scrollDirection: Axis.horizontal,
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 4,
              //   mainAxisSpacing: 10,
              //   crossAxisSpacing: 10,
              //   mainAxisExtent: 100,
              // ),
              itemBuilder: (_, i) {
                if (i == 0) {
                  return SizedBox(
                    height: 100,
                    width: 80,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 75, //width of button
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  shadowColor: Colors
                                      .transparent, //remove shadow on button
                                  primary: MyTheme.primaryMinor,

                                  padding: const EdgeInsets.all(10),

                                  shape: const CircleBorder(),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: MyTheme.primaryMajor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text('เพิ่มรายการใหม่'),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    width: 110,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75, //height of button
                              width: 100, //width of button
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  //elevation: 0.0,
                                  //shadowColor: Colors
                                  //    .transparent, //remove shadow on button
                                  primary: MyTheme.negativeMajor,
                                  textStyle: MyTheme.whiteTextTheme.headline4,
                                  padding: const EdgeInsets.all(10),

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
                                    Text(
                                        debtLongList[i - 1].balance.toString()),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(debtLongList[i - 1].creditor)
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
