import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:collection/collection.dart';

import 'package:windshield/main.dart';
import 'package:windshield/providers/daily_flow_overview_provider.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/ftype_coler.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';

final provOverFlow =
    ChangeNotifierProvider.autoDispose<DailyFlowOverviewProvider>(
        (ref) => DailyFlowOverviewProvider());

final apiOverFlow = FutureProvider.autoDispose<void>((ref) async {
  ref.watch(provOverFlow.select((value) => value.needFetchAPI));
  final now = DateTime.now();
  final data = await ref.read(apiProvider).getAllCategoriesWithBudgetFlows(now);
  final id = await ref.read(apiProvider).getTodayDFId(now);
  ref.read(provOverFlow).setDfId(id);
  ref.read(provOverFlow).setCatList(data);
  ref.read(provOverFlow).setCatType();
  return;
});

final apiDateChange = FutureProvider.autoDispose<void>((ref) async {
  final date = ref.read(provOverFlow).date;
  final data =
      await ref.read(apiProvider).getAllCategoriesWithBudgetFlows(date);
  final id = await ref.read(apiProvider).getTodayDFId(date);
  ref.read(provOverFlow).setDfId(id);
  ref.read(provOverFlow).setCatList(data);
  ref.read(provOverFlow).setCatType();
  return;
});

class DailyFlowOverviewPage extends ConsumerWidget {
  const DailyFlowOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiOverFlow);
    return api.when(
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (_) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 225,
                    // padding: const EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: MyTheme.majorBackground,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'บัญชีรายรับ-รายจ่าย',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(
                                const Duration(days: 365),
                              ),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) {
                              final date = ref.read(provOverFlow).date;
                              final id = await ref
                                  .read(apiProvider)
                                  .getTodayDFId(date);
                              ref.read(provOverFlow).setDfId(id);
                              ref.read(provOverFlow).setDate(picked);
                              ref.read(provOverFlow).setPageIdx(0);
                              AutoRouter.of(context)
                                  .push(const DailyFlowRoute());
                            }
                          },
                          child: Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                              children: [
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: DateFormat(' E d MMMM y').format(
                                    DateTime.now(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const DateList(),
                      ],
                    ),
                  ),
                  const ExpenseIncome(),
                  Expanded(
                    child: ListView(
                      children: const [
                        OverviewIncomeToday(),
                        OverviewExpenseToday(),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                ],
              ),
            ),
          );
        });
  }
}

class DateList extends ConsumerStatefulWidget {
  const DateList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DateListState();
}

class _DateListState extends ConsumerState<DateList> {
  final DatePickerController _controller = DatePickerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.animateToDate(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DatePicker(
        DateTime.now().subtract(const Duration(days: 6)),
        initialSelectedDate: ref.watch(provOverFlow.select((e) => e.date)),
        selectionColor: Colors.white,
        selectedTextColor: MyTheme.primaryMajor,
        daysCount: 7,
        locale: "th_TH",
        width: 70,
        controller: _controller,
        onDateChange: (date) {
          ref.read(provOverFlow).setDate(date);
          ref.refresh(apiDateChange);
        },
      ),
    );
  }
}

class ExpenseIncome extends ConsumerWidget {
  const ExpenseIncome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incTotal = ref.watch(provOverFlow.select((e) => e.incTotal));
    final expTotal = ref.watch(provOverFlow.select((e) => e.expTotal));
    final incLength = ref.watch(provOverFlow.select((e) => e.incFlowsLen));
    final expLength = ref.watch(provOverFlow.select((e) => e.expFlowsLen));
    final api = ref.watch(apiDateChange);
    return api.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      data: (_) => Container(
        height: 200,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                ref.read(provOverFlow).setPageIdx(0);
                AutoRouter.of(context).push(const DailyFlowRoute());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Badge(
                    position: const BadgePosition(top: -10, end: -8),
                    padding: const EdgeInsets.all(8),
                    animationType: BadgeAnimationType.scale,
                    showBadge: true,
                    badgeContent: Text(
                      incLength.toString(),
                      style: MyTheme.whiteTextTheme.headline4,
                    ),
                    child: SizedBox(
                      height: 60, //height of button
                      width: 60, //width of button
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(provOverFlow).setPageIdx(0);
                          AutoRouter.of(context).push(const DailyFlowRoute());
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shadowColor:
                              Colors.transparent, //remove shadow on button
                          primary: Colors.white,

                          textStyle: const TextStyle(fontSize: 12),
                          padding: const EdgeInsets.all(6),

                          shape: const CircleBorder(),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              HelperIcons.getIconData('hand-holding-usd'),
                              color: MyTheme.positiveMajor,
                            ),
                            SizedBox(
                              width: 60,
                              child: AutoSizeText(
                                '+${HelperNumber.format(incTotal)}',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                minFontSize: 0,
                                style: TextStyle(
                                  color: MyTheme.positiveMajor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'รายรับ',
                    style: MyTheme.whiteTextTheme.bodyText1,
                  ),
                  Text(
                    incLength.toString() + ' รายการ',
                    style: MyTheme.whiteTextTheme.bodyText2!.merge(
                      TextStyle(color: Colors.white.withAlpha(200)),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                ref.read(provOverFlow).setPageIdx(1);
                AutoRouter.of(context).push(const DailyFlowRoute());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Badge(
                    position: const BadgePosition(top: -10, end: -8),
                    padding: const EdgeInsets.all(8),
                    animationType: BadgeAnimationType.scale,
                    showBadge: true,
                    badgeContent: Text(
                      expLength.toString(),
                      style: MyTheme.whiteTextTheme.headline4,
                    ),
                    child: SizedBox(
                      height: 60, //height of button
                      width: 60, //width of button
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(provOverFlow).setPageIdx(1);
                          AutoRouter.of(context).push(const DailyFlowRoute());
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shadowColor:
                              Colors.transparent, //remove shadow on button
                          primary: Colors.white,

                          textStyle: const TextStyle(fontSize: 12),
                          padding: const EdgeInsets.all(6),

                          shape: const CircleBorder(),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt,
                              color: MyTheme.negativeMajor,
                            ),
                            SizedBox(
                              width: 60,
                              child: AutoSizeText(
                                '+${HelperNumber.format(expTotal)}',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                minFontSize: 0,
                                style: TextStyle(
                                  color: MyTheme.negativeMajor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'รายจ่าย',
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    expLength.toString() + ' รายการ',
                    style: MyTheme.whiteTextTheme.bodyText2!.merge(
                      TextStyle(color: Colors.white.withAlpha(200)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OverviewIncomeToday extends ConsumerWidget {
  const OverviewIncomeToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final inc = ref.watch(provOverFlow.select((e) => e.tdIncList));
    final inc = ref.watch(provOverFlow).tdIncList;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('รายรับวันนี้', style: MyTheme.textTheme.headline3),
          if (inc.isEmpty) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'ไม่มีรายการ',
                  style: MyTheme.textTheme.headline4,
                ),
              ),
            ),
          ] else ...[
            GridView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: inc.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 120,
              ),
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Badge(
                          position: const BadgePosition(
                            top: -9,
                            end: 2,
                            isCenter: false,
                          ),
                          animationType: BadgeAnimationType.scale,
                          showBadge: true,
                          badgeContent: Text(
                            inc[i].flows.length.toString(),
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
                                  inc[i].flows.map((e) => e.value).sum,
                                  inc[i].budgets.map((e) => e.total).sum,
                                ),
                                backgroundColor: HelperColor.getFtColor(
                                  inc[i].ftype,
                                  1,
                                ),
                                progressColor: HelperColor.getFtColor(
                                  inc[i].ftype,
                                  0,
                                ),
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      HelperIcons.getIconData(inc[i].icon),
                                      color: Colors.white,
                                    ),
                                    if (inc[i].flows.isNotEmpty) ...[
                                      SizedBox(
                                        width: 80,
                                        child: AutoSizeText(
                                          HelperNumber.format(inc[i]
                                              .flows
                                              .map((e) => e.value)
                                              .sum),
                                          maxLines: 1,
                                          minFontSize: 0,
                                          textAlign: TextAlign.center,
                                          style:
                                              MyTheme.whiteTextTheme.bodyText2,
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
                      SizedBox(
                        height: 25,
                        child: AutoSizeText(
                          inc[i].name,
                          style: MyTheme.textTheme.bodyText2,
                          minFontSize: 8,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class OverviewExpenseToday extends ConsumerWidget {
  const OverviewExpenseToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exp = ref.watch(provOverFlow).tdExpList;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('รายจ่ายวันนี้', style: MyTheme.textTheme.headline3),
          if (exp.isEmpty) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'ไม่มีรายการ',
                  style: MyTheme.textTheme.headline4,
                ),
              ),
            ),
          ] else ...[
            GridView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: exp.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 120,
              ),
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Badge(
                          position: const BadgePosition(
                            top: -9,
                            end: 2,
                            isCenter: false,
                          ),
                          animationType: BadgeAnimationType.scale,
                          showBadge: true,
                          badgeContent: Text(
                            exp[i].flows.length.toString(),
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
                                  exp[i].flows.map((e) => e.value).sum,
                                  exp[i].budgets.map((e) => e.total).sum,
                                ),
                                backgroundColor: HelperColor.getFtColor(
                                  exp[i].ftype,
                                  1,
                                ),
                                progressColor: HelperColor.getFtColor(
                                  exp[i].ftype,
                                  0,
                                ),
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      HelperIcons.getIconData(exp[i].icon),
                                      color: Colors.white,
                                    ),
                                    if (exp[i].flows.isNotEmpty) ...[
                                      SizedBox(
                                        width: 80,
                                        child: AutoSizeText(
                                          HelperNumber.format(exp[i]
                                              .flows
                                              .map((e) => e.value)
                                              .sum),
                                          maxLines: 1,
                                          minFontSize: 0,
                                          textAlign: TextAlign.center,
                                          style:
                                              MyTheme.whiteTextTheme.bodyText2,
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
                      SizedBox(
                        height: 25,
                        child: AutoSizeText(
                          exp[i].name,
                          style: MyTheme.textTheme.bodyText2,
                          minFontSize: 8,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
