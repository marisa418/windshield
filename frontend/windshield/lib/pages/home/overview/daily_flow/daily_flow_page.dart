import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:collection/collection.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/daily_flow/category.dart';
import 'package:windshield/models/daily_flow/flow_speech.dart';
import 'package:windshield/pages/home/overview/daily_flow/overview/daily_flow_overview_page.dart';
import 'package:windshield/providers/daily_flow_provider.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/ftype_coler.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';

final provDFlow = ChangeNotifierProvider.autoDispose<DailyFlowProvider>(
    (ref) => DailyFlowProvider());

final apiDFlow = FutureProvider.autoDispose<List<DFlowCategory>>((ref) async {
  ref.watch(provDFlow.select((value) => value.needFetchAPI));
  final date = ref.read(provOverFlow).date;
  final data =
      await ref.read(apiProvider).getAllCategoriesWithBudgetFlows(date);
  ref.read(provDFlow).setCatList(data);
  ref.read(provDFlow).setCatType();
  return data;
});

final apiOldFlow = FutureProvider.autoDispose<void>((ref) async {
  // ref.watch(provDFlow.select((value) => value.needFetchAPI));
  final date = ref.read(provOverFlow).date;
  final start = date.subtract(const Duration(days: 7));
  final end = date.subtract(const Duration(days: 1));
  final data = await ref.read(apiProvider).getRangeDailyFlowSheet(start, end);
  ref.read(provDFlow).setOldFlowSheetList(data);
});

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
    final idx = ref.watch(provOverFlow.select((e) => e.pageIdx));
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
                          'รายรับ ${DateFormat('E d MMM y').format(
                            ref.watch(provOverFlow.select((e) => e.date)),
                          )}',
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
                                  ref.read(provOverFlow).setPageIdx(1),
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
                                      'รายจ่าย\n-$expTotal บ.',
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
                height: 155,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            'สัดส่วนรายรับ',
                            style: MyTheme.textTheme.headline3,
                            // textAlign: TextAlign.l,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (context) => const OldFlowSheetModal(
                                  name: 'รายรับ',
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  color: MyTheme.positiveMajor,
                                ),
                                Text(
                                  'เหมือนวันก่อน',
                                  style: TextStyle(
                                    color: MyTheme.positiveMajor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                      'รายจ่าย ${DateFormat('E d MMM y').format(
                        ref.watch(provOverFlow.select((e) => e.date)),
                      )}',
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
                          onPressed: () => ref.read(provOverFlow).setPageIdx(0)
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
                                  'รายรับ\n+$incTotal บ.',
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
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รายรับจากการทำงาน', style: MyTheme.textTheme.headline3),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Row(children: [
                    Icon(Icons.refresh_rounded, color: MyTheme.positiveMajor),
                    Text('เหมือนวันก่อน',
                        style: TextStyle(color: MyTheme.positiveMajor)),
                  ]),
                  onTap: () {
                    AutoRouter.of(context).push(const SpeechToTextRoute());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: incWorkingList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 120,
            ),
            itemBuilder: (_, i) {
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(provDFlow).setColorBackground('income');
                        ref.read(provDFlow).setCurrCat(incWorkingList[i]);
                        AutoRouter.of(context)
                            .push(const DailyFlowCreateRoute());
                      },
                      child: Badge(
                        position: const BadgePosition(
                          top: -9,
                          end: 2,
                          isCenter: false,
                        ),
                        animationType: BadgeAnimationType.scale,
                        showBadge:
                            incWorkingList[i].flows.isEmpty ? false : true,
                        badgeContent: Text(
                          '${incWorkingList[i].flows.length}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              radius: 40,
                              lineWidth: 40,
                              percent: HelperProgress.getPercent(
                                incWorkingList[i].flows.map((e) => e.value).sum,
                                incWorkingList[i]
                                    .budgets
                                    .map((e) => e.total)
                                    .sum,
                              ),
                              backgroundColor: incWorkingList[i].budgets.isEmpty
                                  ? const Color(0xffE0E0E0)
                                  : HelperColor.getFtColor(
                                      incWorkingList[i].ftype,
                                      1,
                                    ),
                              progressColor: HelperColor.getFtColor(
                                incWorkingList[i].ftype,
                                0,
                              ),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(
                                        incWorkingList[i].icon),
                                    color: Colors.white,
                                  ),
                                  if (incWorkingList[i].flows.isNotEmpty) ...[
                                    SizedBox(
                                      width: 80,
                                      child: AutoSizeText(
                                        HelperNumber.format(incWorkingList[i]
                                            .flows
                                            .map((e) => e.value)
                                            .sum),
                                        maxLines: 1,
                                        minFontSize: 0,
                                        textAlign: TextAlign.center,
                                        style: MyTheme.whiteTextTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      incWorkingList[i].name,
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
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รายรับจากสินทรัพย์', style: MyTheme.textTheme.headline3),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Row(children: [
                    Icon(Icons.refresh_rounded, color: MyTheme.positiveMajor),
                    Text('เหมือนวันก่อน',
                        style: TextStyle(color: MyTheme.positiveMajor)),
                  ]),
                  onTap: () {
                    AutoRouter.of(context).push(const SpeechToTextRoute());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: incAssetList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 120,
            ),
            itemBuilder: (_, i) {
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(provDFlow).setColorBackground('income');
                        ref.read(provDFlow).setCurrCat(incAssetList[i]);
                        AutoRouter.of(context)
                            .push(const DailyFlowCreateRoute());
                      },
                      child: Badge(
                        position: const BadgePosition(
                          top: -9,
                          end: 2,
                          isCenter: false,
                        ),
                        animationType: BadgeAnimationType.scale,
                        showBadge: incAssetList[i].flows.isEmpty ? false : true,
                        badgeContent: Text(
                          '${incAssetList[i].flows.length}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              radius: 40,
                              lineWidth: 40,
                              percent: HelperProgress.getPercent(
                                incAssetList[i].flows.map((e) => e.value).sum,
                                incAssetList[i].budgets.map((e) => e.total).sum,
                              ),
                              backgroundColor: incAssetList[i].budgets.isEmpty
                                  ? const Color(0xffE0E0E0)
                                  : HelperColor.getFtColor(
                                      incAssetList[i].ftype,
                                      1,
                                    ),
                              progressColor: HelperColor.getFtColor(
                                incAssetList[i].ftype,
                                0,
                              ),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(
                                        incAssetList[i].icon),
                                    color: Colors.white,
                                  ),
                                  if (incAssetList[i].flows.isNotEmpty) ...[
                                    SizedBox(
                                      width: 80,
                                      child: AutoSizeText(
                                        HelperNumber.format(incAssetList[i]
                                            .flows
                                            .map((e) => e.value)
                                            .sum),
                                        maxLines: 1,
                                        minFontSize: 0,
                                        textAlign: TextAlign.center,
                                        style: MyTheme.whiteTextTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      incAssetList[i].name,
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
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รายรับจากการลงทุน', style: MyTheme.textTheme.headline3),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Row(children: [
                    Icon(Icons.refresh_rounded, color: MyTheme.positiveMajor),
                    Text('เหมือนวันก่อน',
                        style: TextStyle(color: MyTheme.positiveMajor)),
                  ]),
                  onTap: () {
                    AutoRouter.of(context).push(const SpeechToTextRoute());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: incOtherList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 120,
            ),
            itemBuilder: (_, i) {
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(provDFlow).setColorBackground('income');
                        ref.read(provDFlow).setCurrCat(incOtherList[i]);
                        AutoRouter.of(context)
                            .push(const DailyFlowCreateRoute());
                      },
                      child: Badge(
                        position: const BadgePosition(
                          top: -9,
                          end: 2,
                          isCenter: false,
                        ),
                        animationType: BadgeAnimationType.scale,
                        showBadge: incOtherList[i].flows.isEmpty ? false : true,
                        badgeContent: Text(
                          '${incOtherList[i].flows.length}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              radius: 40,
                              lineWidth: 40,
                              percent: HelperProgress.getPercent(
                                incOtherList[i].flows.map((e) => e.value).sum,
                                incOtherList[i].budgets.map((e) => e.total).sum,
                              ),
                              backgroundColor: incOtherList[i].budgets.isEmpty
                                  ? const Color(0xffE0E0E0)
                                  : HelperColor.getFtColor(
                                      incOtherList[i].ftype,
                                      1,
                                    ),
                              progressColor: HelperColor.getFtColor(
                                incOtherList[i].ftype,
                                0,
                              ),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(
                                        incOtherList[i].icon),
                                    color: Colors.white,
                                  ),
                                  if (incOtherList[i].flows.isNotEmpty) ...[
                                    SizedBox(
                                      width: 80,
                                      child: AutoSizeText(
                                        HelperNumber.format(incOtherList[i]
                                            .flows
                                            .map((e) => e.value)
                                            .sum),
                                        maxLines: 1,
                                        minFontSize: 0,
                                        textAlign: TextAlign.center,
                                        style: MyTheme.whiteTextTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      incOtherList[i].name,
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
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รายจ่ายไม่คงที่', style: MyTheme.textTheme.headline3),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Row(children: [
                    Icon(Icons.refresh_rounded, color: MyTheme.negativeMajor),
                    Text('เหมือนวันก่อน',
                        style: TextStyle(color: MyTheme.negativeMajor)),
                  ]),
                  onTap: () {
                    AutoRouter.of(context).push(const SpeechToTextRoute());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: expNonConList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 120,
            ),
            itemBuilder: (_, i) {
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(provDFlow).setColorBackground('exp');
                        ref.read(provDFlow).setCurrCat(expNonConList[i]);
                        AutoRouter.of(context)
                            .push(const DailyFlowCreateRoute());
                      },
                      child: Badge(
                        position: const BadgePosition(
                          top: -9,
                          end: 2,
                          isCenter: false,
                        ),
                        animationType: BadgeAnimationType.scale,
                        showBadge:
                            expNonConList[i].flows.isEmpty ? false : true,
                        badgeContent: Text(
                          '${expNonConList[i].flows.length}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              radius: 40,
                              lineWidth: 40,
                              percent: HelperProgress.getPercent(
                                expNonConList[i].flows.map((e) => e.value).sum,
                                expNonConList[i]
                                    .budgets
                                    .map((e) => e.total)
                                    .sum,
                              ),
                              backgroundColor: expNonConList[i].budgets.isEmpty
                                  ? const Color(0xffE0E0E0)
                                  : HelperColor.getFtColor(
                                      expNonConList[i].ftype,
                                      1,
                                    ),
                              progressColor: HelperColor.getFtColor(
                                expNonConList[i].ftype,
                                0,
                              ),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(
                                        expNonConList[i].icon),
                                    color: Colors.white,
                                  ),
                                  if (expNonConList[i].flows.isNotEmpty) ...[
                                    SizedBox(
                                      width: 80,
                                      child: AutoSizeText(
                                        HelperNumber.format(expNonConList[i]
                                            .flows
                                            .map((e) => e.value)
                                            .sum),
                                        maxLines: 1,
                                        minFontSize: 0,
                                        textAlign: TextAlign.center,
                                        style: MyTheme.whiteTextTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      expNonConList[i].name,
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
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รายจ่ายคงที่', style: MyTheme.textTheme.headline3),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Row(children: [
                    Icon(Icons.refresh_rounded, color: MyTheme.negativeMajor),
                    Text('เหมือนวันก่อน',
                        style: TextStyle(color: MyTheme.negativeMajor)),
                  ]),
                  onTap: () {
                    AutoRouter.of(context).push(const SpeechToTextRoute());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: expConList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 120,
            ),
            itemBuilder: (_, i) {
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(provDFlow).setColorBackground('exp');
                        ref.read(provDFlow).setCurrCat(expConList[i]);
                        AutoRouter.of(context)
                            .push(const DailyFlowCreateRoute());
                      },
                      child: Badge(
                        position: const BadgePosition(
                          top: -9,
                          end: 2,
                          isCenter: false,
                        ),
                        animationType: BadgeAnimationType.scale,
                        showBadge: expConList[i].flows.isEmpty ? false : true,
                        badgeContent: Text(
                          '${expConList[i].flows.length}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              radius: 40,
                              lineWidth: 40,
                              percent: HelperProgress.getPercent(
                                expConList[i].flows.map((e) => e.value).sum,
                                expConList[i].budgets.map((e) => e.total).sum,
                              ),
                              backgroundColor: expConList[i].budgets.isEmpty
                                  ? const Color(0xffE0E0E0)
                                  : HelperColor.getFtColor(
                                      expConList[i].ftype,
                                      1,
                                    ),
                              progressColor: HelperColor.getFtColor(
                                expConList[i].ftype,
                                0,
                              ),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(expConList[i].icon),
                                    color: Colors.white,
                                  ),
                                  if (expConList[i].flows.isNotEmpty) ...[
                                    SizedBox(
                                      width: 80,
                                      child: AutoSizeText(
                                        HelperNumber.format(expConList[i]
                                            .flows
                                            .map((e) => e.value)
                                            .sum),
                                        maxLines: 1,
                                        minFontSize: 0,
                                        textAlign: TextAlign.center,
                                        style: MyTheme.whiteTextTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      expConList[i].name,
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
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('การออมเเละการลงทุน', style: MyTheme.textTheme.headline3),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Row(children: [
                    Icon(Icons.refresh_rounded, color: MyTheme.negativeMajor),
                    Text('เหมือนวันก่อน',
                        style: TextStyle(color: MyTheme.negativeMajor)),
                  ]),
                  onTap: () {
                    AutoRouter.of(context).push(const SpeechToTextRoute());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: savInvList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 120,
            ),
            itemBuilder: (_, i) {
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(provDFlow).setColorBackground('exp');
                        ref.read(provDFlow).setCurrCat(savInvList[i]);
                        AutoRouter.of(context)
                            .push(const DailyFlowCreateRoute());
                      },
                      child: Badge(
                        position: const BadgePosition(
                          top: -9,
                          end: 2,
                          isCenter: false,
                        ),
                        animationType: BadgeAnimationType.scale,
                        showBadge: savInvList[i].flows.isEmpty ? false : true,
                        badgeContent: Text(
                          '${savInvList[i].flows.length}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              radius: 40,
                              lineWidth: 40,
                              percent: HelperProgress.getPercent(
                                savInvList[i].flows.map((e) => e.value).sum,
                                savInvList[i].budgets.map((e) => e.total).sum,
                              ),
                              backgroundColor: savInvList[i].budgets.isEmpty
                                  ? const Color(0xffE0E0E0)
                                  : HelperColor.getFtColor(
                                      savInvList[i].ftype,
                                      1,
                                    ),
                              progressColor: HelperColor.getFtColor(
                                savInvList[i].ftype,
                                0,
                              ),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HelperIcons.getIconData(savInvList[i].icon),
                                    color: Colors.white,
                                  ),
                                  if (savInvList[i].flows.isNotEmpty) ...[
                                    SizedBox(
                                      width: 80,
                                      child: AutoSizeText(
                                        HelperNumber.format(savInvList[i]
                                            .flows
                                            .map((e) => e.value)
                                            .sum),
                                        maxLines: 1,
                                        minFontSize: 0,
                                        textAlign: TextAlign.center,
                                        style: MyTheme.whiteTextTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      savInvList[i].name,
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

class OldFlowSheetModal extends ConsumerWidget {
  const OldFlowSheetModal({
    required this.name,
    Key? key,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiOldFlow);
    final oldSheets = ref.watch(provDFlow.select((e) => e.oldFlowSheetList));
    return api.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (_) => Center(
        child: Container(
          height: MediaQuery.of(context).size.height - 200,
          width: MediaQuery.of(context).size.width - 50,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(name, style: MyTheme.textTheme.headline3),
                  GestureDetector(
                    onTap: () => AutoRouter.of(context).pop(),
                    child: const Icon(Icons.close, size: 30),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: oldSheets.length,
                  shrinkWrap: true,
                  itemBuilder: (_, i) {
                    return FlowSheetTile(i: i);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlowSheetTile extends ConsumerWidget {
  const FlowSheetTile({required this.i, Key? key}) : super(key: key);
  final int i;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(provDFlow.select((e) => e.oldFlowSheetList[i]));
    final cat = ref.read(provDFlow).categorizeOldFlow(sheet);
    if (sheet.flows.isEmpty) return Container();
    return GestureDetector(
      onTap: () async {
        List<SpeechFlow> flows = [];
        for (var flow in sheet.flows) {
          final temp = SpeechFlow(
            dfId: ref.read(provOverFlow).dfId,
            cat: SpeechCat(id: flow.cat.id, icon: '', color: Colors.white),
            name: flow.name,
            value: flow.value,
            method: flow.method.id,
            key: '',
          );
          flows.add(temp);
        }
        final complete = await ref.read(apiProvider).addFlowList(flows);

        if (complete) {
          ref.read(provDFlow).setNeedFetchAPI();
          ref.read(provOverFlow).setNeedFetchAPI();
          ref.refresh(apiDateChange);
          AutoRouter.of(context).pop();
        }
      },
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              DateFormat('E d MMM').format(sheet.date),
            ),
            const Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: cat.length,
                  itemBuilder: (_, i) => SizedBox(
                    height: 100,
                    width: 75,
                    child: Column(
                      children: [
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HelperColor.getFtColor(
                              cat[i].ftype,
                              0,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                HelperIcons.getIconData(cat[i].icon),
                                color: Colors.white,
                              ),
                              AutoSizeText(
                                HelperNumber.format(cat[i].total),
                                style: MyTheme.whiteTextTheme.bodyText1,
                                minFontSize: 0,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: AutoSizeText(
                              cat[i].name,
                              style: MyTheme.textTheme.bodyText2,
                              minFontSize: 0,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
