import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/daily_flow/flow.dart';
import 'package:windshield/pages/home/overview/statement/first_statement.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/icon_convertor.dart';

class DailyFlowPage extends ConsumerWidget {
  const DailyFlowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiDFlow);
    return api.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                const DailyList(),
                Container(
                  color: Colors.white,
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

//ตั้งแต่บนจนก่อนถึงปุ่มย้อนกลับ
class DailyList extends ConsumerWidget {
  const DailyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(provDFlow.select((e) => e.pageIdx));
    final incTotal = ref.watch(provDFlow.select((e) => e.incTotal));
    final expTotal = ref.watch(provDFlow.select((e) => e.expTotal));
    final incWorking = ref.watch(provDFlow.select((e) => e.incWorkingTotal));
    final incAsset = ref.watch(provDFlow.select((e) => e.incAssetTotal));
    final incOther = ref.watch(provDFlow.select((e) => e.incOtherTotal));
    final expIncon = ref.watch(provDFlow.select((e) => e.expInconTotal));
    final expCon = ref.watch(provDFlow.select((e) => e.expConTotal));
    final savInv = ref.watch(provDFlow.select((e) => e.savAndInvTotal));
    if (idx == 0) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: 160,
                    width: 450,
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 15,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        colors: MyTheme.incomeBackground,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'บัญชีรายรับ',
                              style: MyTheme.whiteTextTheme.headline1,
                            ),
                          ],
                        ),
                        Text(
                          'รายรับวันนี้',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '+$incTotal บ.',
                              style: MyTheme.whiteTextTheme.headline2,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                padding: const EdgeInsets.only(left: 20),
                                minimumSize: const Size(50, 50),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ), // Background color
                              ),
                              onPressed: () =>
                                  ref.read(provDFlow).setPageIdx(1),
                              // Respond to button press
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.receipt,
                                    size: 20.0,
                                    color: MyTheme.negativeMajor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'รายจ่ายวันนี้\n-$expTotal บ.',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: MyTheme.negativeMajor,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    size: 40.0,
                                    color: MyTheme.negativeMajor,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        'สัดส่วนรายรับ',
                        style: MyTheme.textTheme.headline3,
                        // textAlign: TextAlign.l,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 4,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => AutoRouter.of(context)
                                  .push(const SpeechToTextRoute()),
                              child: CircularPercentIndicator(
                                radius: 50,
                                lineWidth: 8,
                                percent: 1,
                                progressColor: MyTheme.positiveMajor,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.mic,
                                      size: 45,
                                      color: MyTheme.positiveMajor,
                                    ),
                                    Text(
                                      'เพิ่มด้วยเสียง',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: MyTheme.positiveMajor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'รายรับจากการทำงาน',
                                    ),
                                    Text(
                                      '$incWorking บ.',
                                      style: TextStyle(
                                        color: MyTheme.positiveMajor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'รายรับจากสินทรัพย์',
                                    ),
                                    Text(
                                      '$incAsset บ.',
                                      style: TextStyle(
                                        color: MyTheme.positiveMajor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'รายรับจากแหล่งอื่นๆ',
                                    ),
                                    Text(
                                      '$incOther บ.',
                                      style: TextStyle(
                                        color: MyTheme.positiveMajor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const IncWorkingTab(),
              const IncAssetTab(),
              const IncOtherTab(),
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 160,
                width: 450,
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 15,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    colors: MyTheme.expenseBackground,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'บัญชีรายจ่าย',
                          style: MyTheme.whiteTextTheme.headline1,
                        ),
                      ],
                    ),
                    Text(
                      'รายจ่ายวันนี้',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '-$expTotal บ.',
                          style: MyTheme.whiteTextTheme.headline2,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: const EdgeInsets.only(left: 20),
                            minimumSize: const Size(50, 50),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ), // Background color
                          ),
                          onPressed: () => ref.read(provDFlow).setPageIdx(0)
                          // Respond to button press
                          ,
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.handHoldingUsd,
                                size: 20.0,
                                color: MyTheme.positiveMajor,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'รายรับวันนี้\n+$incTotal บ.',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: MyTheme.positiveMajor,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_right,
                                size: 40.0,
                                color: MyTheme.positiveMajor,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        'สัดส่วนรายจ่าย',
                        style: MyTheme.textTheme.headline3,
                        // textAlign: TextAlign.l,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 4,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => AutoRouter.of(context)
                                  .push(const SpeechToTextRoute()),
                              child: CircularPercentIndicator(
                                radius: 50,
                                lineWidth: 8,
                                percent: 1,
                                progressColor: MyTheme.negativeMajor,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.mic,
                                      size: 45,
                                      color: MyTheme.negativeMajor,
                                    ),
                                    Text(
                                      'เพิ่มด้วยเสียง',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: MyTheme.negativeMajor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'รายจ่ายไม่คงที่',
                                    ),
                                    Text(
                                      '$expIncon บ.',
                                      style: TextStyle(
                                        color: MyTheme.negativeMajor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'รายจ่ายคงที่',
                                    ),
                                    Text(
                                      '$expCon บ.',
                                      style: TextStyle(
                                        color: MyTheme.negativeMajor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'การออมและการลงทุน',
                                    ),
                                    Text(
                                      '$savInv บ.',
                                      style: TextStyle(
                                        color: MyTheme.negativeMajor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const ExpNonConTab(),
              const ExpConTab(),
              const SavAndInvTab(),
            ],
          ),
        ),
      );
    }
  }
}

class IncWorkingTab extends ConsumerWidget {
  const IncWorkingTab({Key? key}) : super(key: key);

  get incWorking => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorkingList = ref.watch(provDFlow.select((e) => e.incWorkingList));

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('รายรับจากการทำงาน', style: MyTheme.textTheme.headline3),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: incWorkingList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 100,
            ),
            itemBuilder: (_, index) {
              return Column(
                children: [
                  Expanded(
                    child: Badge(
                      position: const BadgePosition(
                        top: -9,
                        end: 2,
                        isCenter: false,
                      ),
                      animationType: BadgeAnimationType.scale,
                      showBadge:
                          incWorkingList[index].flows.isEmpty ? false : true,
                      badgeContent: Text(
                        '${incWorkingList[index].flows.length}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 75, //height of button
                            width: 75, //width of button
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(provDFlow)
                                    .setColorBackground('income');
                                ref
                                    .read(provDFlow)
                                    .setCurrCat(incWorkingList[index]);
                                AutoRouter.of(context)
                                    .push(const DailyFlowCreateRoute());
                                ref.watch(provDFlow).currCat.flows;
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                shadowColor: Colors
                                    .transparent, //remove shadow on button
                                primary: incWorkingList[index].budgets.isEmpty
                                    ? const Color(0xffE0E0E0)
                                    : MyTheme.incomeWorking[0],
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.all(10),

                                shape: const CircleBorder(),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(
                                        incWorkingList[index].icon),
                                    color: Colors.white,
                                  ),
                                  if (incWorkingList[index]
                                      .flows
                                      .isNotEmpty) ...[
                                    Text(
                                      _loopFlow(incWorkingList[index].flows),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      incWorkingList[index].name,
                      style: MyTheme.textTheme.bodyText2,
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class IncAssetTab extends ConsumerWidget {
  const IncAssetTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incAssetList = ref.watch(provDFlow.select((e) => e.incAssetList));
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('รายรับจากสินทรัพย์', style: MyTheme.textTheme.headline3),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: incAssetList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 100,
            ),
            itemBuilder: (_, index) {
              return Column(
                children: [
                  Expanded(
                    child: Badge(
                      position: const BadgePosition(
                        top: -9,
                        end: 2,
                        isCenter: false,
                      ),
                      animationType: BadgeAnimationType.scale,
                      showBadge:
                          incAssetList[index].flows.isEmpty ? false : true,
                      badgeContent: Text(
                        '${incAssetList[index].flows.length}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 75, //height of button
                            width: 75, //width of button
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(provDFlow)
                                    .setColorBackground('income');
                                ref
                                    .read(provDFlow)
                                    .setCurrCat(incAssetList[index]);
                                AutoRouter.of(context)
                                    .push(const DailyFlowCreateRoute());
                                ref.watch(provDFlow).currCat.flows;
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                shadowColor: Colors
                                    .transparent, //remove shadow on button
                                primary: incAssetList[index].budgets.isEmpty
                                    ? const Color(0xffE0E0E0)
                                    : MyTheme.incomeAsset[0],
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.all(10),

                                shape: const CircleBorder(),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(
                                        incAssetList[index].icon),
                                    color: Colors.white,
                                  ),
                                  if (incAssetList[index].flows.isNotEmpty) ...[
                                    Text(
                                      _loopFlow(incAssetList[index].flows),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      incAssetList[index].name,
                      style: MyTheme.textTheme.bodyText2,
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class IncOtherTab extends ConsumerWidget {
  const IncOtherTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incOtherList = ref.watch(provDFlow.select((e) => e.incOtherList));
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('รายรับอื่นๆ', style: MyTheme.textTheme.headline3),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: incOtherList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 100,
            ),
            itemBuilder: (_, index) {
              return Column(
                children: [
                  Expanded(
                    child: Badge(
                      position: const BadgePosition(
                        top: -9,
                        end: 2,
                        isCenter: false,
                      ),
                      animationType: BadgeAnimationType.scale,
                      showBadge:
                          incOtherList[index].flows.isEmpty ? false : true,
                      badgeContent: Text(
                        '${incOtherList[index].flows.length}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 75, //height of button
                            width: 75, //width of button
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(provDFlow)
                                    .setColorBackground('income');
                                ref
                                    .read(provDFlow)
                                    .setCurrCat(incOtherList[index]);
                                AutoRouter.of(context)
                                    .push(const DailyFlowCreateRoute());
                                ref.watch(provDFlow).currCat.flows;
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                shadowColor: Colors
                                    .transparent, //remove shadow on button
                                primary: incOtherList[index].budgets.isEmpty
                                    ? const Color(0xffE0E0E0)
                                    : MyTheme.incomeOther[0],
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.all(10),

                                shape: const CircleBorder(),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(
                                        incOtherList[index].icon),
                                    color: Colors.white,
                                  ),
                                  if (incOtherList[index].flows.isNotEmpty) ...[
                                    Text(
                                      _loopFlow(incOtherList[index].flows),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      incOtherList[index].name,
                      style: MyTheme.textTheme.bodyText2,
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ExpNonConTab extends ConsumerWidget {
  const ExpNonConTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expNonConList = ref.watch(provDFlow.select((e) => e.expInconList));
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('รายจ่ายไม่คงที่', style: MyTheme.textTheme.headline3),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: expNonConList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 100,
            ),
            itemBuilder: (_, index) {
              return Column(
                children: [
                  Expanded(
                    child: Badge(
                      position: const BadgePosition(
                        top: -9,
                        end: 2,
                        isCenter: false,
                      ),
                      animationType: BadgeAnimationType.scale,
                      showBadge:
                          expNonConList[index].flows.isEmpty ? false : true,
                      badgeContent: Text(
                        '${expNonConList[index].flows.length}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 75, //height of button
                            width: 75, //width of button
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(provDFlow).setColorBackground('exp');
                                ref
                                    .read(provDFlow)
                                    .setCurrCat(expNonConList[index]);
                                AutoRouter.of(context)
                                    .push(const DailyFlowCreateRoute());
                                ref.watch(provDFlow).currCat.flows;
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                shadowColor: Colors
                                    .transparent, //remove shadow on button
                                primary: expNonConList[index].budgets.isEmpty
                                    ? const Color(0xffE0E0E0)
                                    : MyTheme.expenseInconsist[0],
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.all(10),

                                shape: const CircleBorder(),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(
                                        expNonConList[index].icon),
                                    color: Colors.white,
                                  ),
                                  if (expNonConList[index]
                                      .flows
                                      .isNotEmpty) ...[
                                    Text(
                                      _loopFlow(expNonConList[index].flows),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      expNonConList[index].name,
                      style: MyTheme.textTheme.bodyText2,
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ExpConTab extends ConsumerWidget {
  const ExpConTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expConList = ref.watch(provDFlow.select((e) => e.expConList));
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('รายจ่ายคงที่', style: MyTheme.textTheme.headline3),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: expConList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 100,
            ),
            itemBuilder: (_, index) {
              return Column(
                children: [
                  Expanded(
                    child: Badge(
                      position: const BadgePosition(
                        top: -9,
                        end: 2,
                        isCenter: false,
                      ),
                      animationType: BadgeAnimationType.scale,
                      showBadge: expConList[index].flows.isEmpty ? false : true,
                      badgeContent: Text(
                        '${expConList[index].flows.length}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 75, //height of button
                            width: 75, //width of button
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(provDFlow).setColorBackground('exp');
                                ref
                                    .read(provDFlow)
                                    .setCurrCat(expConList[index]);
                                AutoRouter.of(context)
                                    .push(const DailyFlowCreateRoute());
                                ref.watch(provDFlow).currCat.flows;
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                shadowColor: Colors
                                    .transparent, //remove shadow on button
                                primary: expConList[index].budgets.isEmpty
                                    ? const Color(0xffE0E0E0)
                                    : MyTheme.expenseConsist[0],
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.all(10),

                                shape: const CircleBorder(),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(
                                        expConList[index].icon),
                                    color: Colors.white,
                                  ),
                                  if (expConList[index].flows.isNotEmpty) ...[
                                    Text(
                                      _loopFlow(expConList[index].flows),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      expConList[index].name,
                      style: MyTheme.textTheme.bodyText2,
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class SavAndInvTab extends ConsumerWidget {
  const SavAndInvTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savInvList = ref.watch(provDFlow.select((e) => e.savAndInvList));
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('การออมและการลงทุน', style: MyTheme.textTheme.headline3),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: savInvList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 100,
            ),
            itemBuilder: (_, index) {
              return Column(
                children: [
                  Expanded(
                    child: Badge(
                      position: const BadgePosition(
                        top: -9,
                        end: 2,
                        isCenter: false,
                      ),
                      animationType: BadgeAnimationType.scale,
                      showBadge: savInvList[index].flows.isEmpty ? false : true,
                      badgeContent: Text(
                        '${savInvList[index].flows.length}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 75, //height of button
                            width: 75, //width of button
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(provDFlow).setColorBackground('exp');
                                ref
                                    .read(provDFlow)
                                    .setCurrCat(savInvList[index]);
                                AutoRouter.of(context)
                                    .push(const DailyFlowCreateRoute());
                                ref.watch(provDFlow).currCat.flows;
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                shadowColor: Colors
                                    .transparent, //remove shadow on button
                                primary: savInvList[index].budgets.isEmpty
                                    ? const Color(0xffE0E0E0)
                                    : MyTheme.savingAndInvest[0],
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.all(10),

                                shape: const CircleBorder(),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(
                                        savInvList[index].icon),
                                    color: Colors.white,
                                  ),
                                  if (savInvList[index].flows.isNotEmpty) ...[
                                    Text(
                                      _loopFlow(savInvList[index].flows),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      savInvList[index].name,
                      style: MyTheme.textTheme.bodyText2,
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

String _loopFlow(List<DFlowFlow> flows) {
  double sum = 0;
  for (var e in flows) {
    sum += e.value;
  }
  return sum.toString();
}
