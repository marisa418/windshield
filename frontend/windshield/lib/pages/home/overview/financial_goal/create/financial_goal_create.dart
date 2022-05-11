import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:windshield/components/loading.dart';
import 'package:windshield/main.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/utility/number_formatter.dart';
import '../financial_goal_page.dart';

class MainOfForm extends ConsumerWidget {
  const MainOfForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMainForm = ref.watch(provFGoal.select((value) => value.isMainForm));
    return WillPopScope(
      onWillPop: () async {
        if (!isMainForm) {
          ref.read(provFGoal).setIsMainForm(true);
          final startDate = ref.read(provFGoal).start;
          final goalDate = ref.read(provFGoal).goalDate;
          final goal = ref.read(provFGoal).goal;
          final term = ref.read(provFGoal).periodTerm;
          final prog = ref.read(provFGoal).progPerPeriod;

          if (goalDate != null) {
            final dateDiff = daysBetween(startDate, goalDate) + 1;
            if (term == 'ALY') {
              final atleast = (goal / (dateDiff / 365).ceil()).ceilToDouble();
              if (prog < atleast) ref.read(provFGoal).setProgPerPeriod(0);
            } else if (term == 'MLY') {
              final atleast = (goal / (dateDiff / 30).ceil()).ceilToDouble();
              if (prog < atleast) ref.read(provFGoal).setProgPerPeriod(0);
            } else if (term == 'WLY') {
              final atleast = (goal / (dateDiff / 7).ceil()).ceilToDouble();
              if (prog < atleast) ref.read(provFGoal).setProgPerPeriod(0);
            } else {
              final atleast = (goal / dateDiff).ceilToDouble();
              if (prog < atleast) ref.read(provFGoal).setProgPerPeriod(0);
            }
          }

          return false;
        }
        return true;
      },
      child: SizedBox(
        height: 600,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: 70,
              decoration: BoxDecoration(
                color: MyTheme.primaryMajor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: TextFormField(
                initialValue: ref.watch(provFGoal).name,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: MyTheme.whiteTextTheme.headline4,
                onChanged: (e) {
                  ref.read(provFGoal).setName(e);
                },
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: Colors.white,
                child: isMainForm
                    ? const ShowBottomPageOne()
                    : const ShowBottomPageTwo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowBottomPageOne extends ConsumerWidget {
  const ShowBottomPageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(provFGoal.select((e) => e.goal));
    final progPerPeriod = ref.watch(provFGoal.select((e) => e.progPerPeriod));
    final start = ref.watch(provFGoal.select((e) => e.start));
    final goalDate = ref.watch(provFGoal.select((e) => e.goalDate));
    final periodTerm = ref.watch(provFGoal.select((e) => e.periodTerm));
    final icon = ref.watch(provFGoal.select((e) => e.icon));
    final isAdd = ref.watch(provFGoal.select((e) => e.isAdd));
    return Column(
      children: [
        SizedBox(
          height: 450,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              children: [
                const SizedBox(height: 20),

                Container(
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Container(
                            height: 50,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(255, 44, 44, 44)
                                    .withOpacity(0.2),
                                width: 1,
                              ),
                              borderRadius: new BorderRadius.circular(32),
                            ),
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.right,
                                initialValue: goal == 0 ? '' : goal.toString(),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'จำนวนเงิน.',
                                  hintStyle:
                                      MyTheme.whiteTextTheme.headline3!.merge(
                                    TextStyle(
                                      color:
                                          const Color.fromARGB(255, 44, 44, 44)
                                              .withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                onChanged: (e) {
                                  ref
                                      .read(provFGoal)
                                      .setGoal(double.tryParse(e) ?? 0);
                                  ref.read(provFGoal).setProgPerPeriod(0);
                                },
                                style: MyTheme.whiteTextTheme.headline3!.merge(
                                  TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: InkWell(
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyTheme.primaryMajor,
                              ),
                              child: Icon(
                                IconsFinance.getIconData(
                                    ref.watch(provFGoal).icon),
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                isScrollControlled: true,
                                // builder: (_) {
                                //   return page2();
                                // }
                                builder: (context) {
                                  return SizedBox(
                                      height: 530, child: ChooseIcons());
                                },
                              );
                            },
                          ),
                        ),
                      ), //Containerxt
                      //Container //Container
                    ], //<Widget>[]
                  ),
                ), //Stack
                //Center

                const SizedBox(height: 20),
                //if (isAdd)
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 44, 44, 44)
                          .withOpacity(0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return CupertinoTheme(
                            data: const CupertinoThemeData(
                              brightness: Brightness.dark,
                            ),
                            child: SizedBox(
                              height: 200,
                              child: CupertinoDatePicker(
                                backgroundColor: Colors.black87,
                                initialDateTime: start,
                                minimumDate: DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                ),
                                maximumDate: DateTime.now().add(
                                  const Duration(days: 1500),
                                ),
                                maximumYear: DateTime.now().year + 100,
                                minuteInterval: 1,
                                mode: CupertinoDatePickerMode.date,
                                use24hFormat: true,
                                onDateTimeChanged: (e) {
                                  ref.read(provFGoal).setStart(e);
                                  if (goalDate != null) {
                                    int dateDiff = daysBetween(e, goalDate) + 1;
                                    double? atleast;
                                    if (periodTerm == 'ALY') {
                                      atleast = goal / (dateDiff / 365).ceil();
                                      atleast.ceilToDouble();
                                    } else if (periodTerm == 'MLY') {
                                      atleast = goal / (dateDiff / 30).ceil();
                                      atleast.ceilToDouble();
                                    } else if (periodTerm == 'WLY') {
                                      atleast = goal / (dateDiff / 7).ceil();
                                      atleast.ceilToDouble();
                                    } else {
                                      atleast = goal / dateDiff;
                                      atleast.ceilToDouble();
                                    }
                                    if (progPerPeriod < atleast) {
                                      ref.read(provFGoal).setProgPerPeriod(0);
                                    }
                                    if (dateDiff < 1) {
                                      ref.read(provFGoal).setGoalDate(null);
                                      ref.read(provFGoal).setDateDiff(null);
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 44, 44, 44)
                              .withOpacity(0.2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: Text(
                        'เริ่มต้น: ${DateFormat(' E d MMM y').format(start)}',
                        style: MyTheme.textTheme.headline3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (goal == null || goal == 0 || goal < 0) {
                    } else {
                      ref.read(provFGoal).setIsMainForm(false);
                    }
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 44, 44, 44)
                            .withOpacity(0.2),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Text(
                      (() {
                        if (progPerPeriod == 0) {
                          return "โดยการ";
                        } else if (ref.watch(provFGoal).periodTerm == "ALY") {
                          return 'เก็บเงิน $progPerPeriod บ./ปี';
                        } else if (ref.watch(provFGoal).periodTerm == "MLY") {
                          return 'เก็บเงิน $progPerPeriod บ./เดือน';
                        } else if (ref.watch(provFGoal).periodTerm == "WLY") {
                          return 'เก็บเงิน $progPerPeriod บ./สัปดาห์';
                        } else {
                          return 'เก็บเงิน $progPerPeriod บ./วัน';
                        }
                      })(),
                      style: progPerPeriod == 0
                          ? MyTheme.whiteTextTheme.headline3!.merge(
                              TextStyle(
                                color: const Color.fromARGB(255, 44, 44, 44)
                                    .withOpacity(0.2),
                              ),
                            )
                          : MyTheme.textTheme.headline3,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // if (isAdd)
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 44, 44, 44)
                          .withOpacity(0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return CupertinoTheme(
                            data: const CupertinoThemeData(
                              brightness: Brightness.dark,
                            ),
                            child: SizedBox(
                              height: 200,
                              child: CupertinoDatePicker(
                                backgroundColor: Colors.black87,
                                initialDateTime: goalDate ??
                                    DateTime(
                                      start.year,
                                      start.month,
                                      start.day + 1,
                                    ),
                                minimumDate: DateTime(
                                  start.year,
                                  start.month,
                                  start.day + 1,
                                ),
                                maximumDate: DateTime.now().add(
                                  const Duration(days: 1500),
                                ),
                                maximumYear: DateTime.now().year + 100,
                                minuteInterval: 1,
                                mode: CupertinoDatePickerMode.date,
                                use24hFormat: true,
                                onDateTimeChanged: (e) {
                                  ref.read(provFGoal).setGoalDate(e);
                                  final dateDiff = daysBetween(start, e) + 1;
                                  double? atleast;
                                  if (periodTerm == 'ALY') {
                                    atleast = goal / (dateDiff / 365).ceil();
                                    atleast.ceilToDouble();
                                  } else if (periodTerm == 'MLY') {
                                    atleast = goal / (dateDiff / 30).ceil();
                                    atleast.ceilToDouble();
                                  } else if (periodTerm == 'WLY') {
                                    atleast = goal / (dateDiff / 7).ceil();
                                    atleast.ceilToDouble();
                                  } else {
                                    atleast = goal / dateDiff;
                                    atleast.ceilToDouble();
                                  }
                                  if (progPerPeriod < atleast) {
                                    ref.read(provFGoal).setProgPerPeriod(0);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 44, 44, 44)
                              .withOpacity(0.2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: goalDate != null
                          ? Text(
                              'สิ้นสุด: ${DateFormat(' E d MMM y').format(goalDate)}',
                              style: MyTheme.textTheme.headline3,
                            )
                          : Text(
                              'สิ้นสุด',
                              style: MyTheme.whiteTextTheme.headline3!.merge(
                                TextStyle(
                                  color: const Color.fromARGB(255, 44, 44, 44)
                                      .withOpacity(0.2),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.all(0)),
        SizedBox(
          height: 50,
          width: 360,
          child: RaisedButton(
            color: goal == 0 || progPerPeriod == 0
                ? Color(0xFFECECEC)
                : Color(0xFF5236FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: Text(
              "บันทึก",
              style: MyTheme.whiteTextTheme.headline3!.merge(
                TextStyle(
                    color: goal == 0 || progPerPeriod == 0
                        ? Color(0xFF565656)
                        : Colors.white),
              ),
            ),
            onPressed: () async {
              if (goal == 0 || progPerPeriod == 0) {
              } else {
                showLoading(context);
                bool complete = false;
                if (ref.read(provFGoal).isAdd) {
                  complete = await ref.read(apiProvider).addGoal(
                        ref.read(provFGoal).name,
                        icon,
                        goal,
                        start,
                        goalDate,
                        periodTerm,
                        progPerPeriod,
                      );
                } else {
                  complete = await ref.read(apiProvider).editGoal(
                        ref.read(provFGoal).id,
                        ref.read(provFGoal).name,
                        icon,
                        goal,
                        start,
                        goalDate,
                        periodTerm,
                        progPerPeriod,
                      );
                }
                if (complete) {
                  ref.read(provFGoal).setNeedFetchAPI();
                  AutoRouter.of(context)
                      .popUntilRouteWithName('FinancialGoalRoute');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('เกิดข้อผิดพลาด')),
                  );
                  AutoRouter.of(context).pop();
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

class ShowBottomPageTwo extends ConsumerWidget {
  const ShowBottomPageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        BottomPageTwoHeader(),
        BottomPageTwoBody(),
        Botton(),
      ],
    );
  }
}

class BottomPageTwoHeader extends ConsumerStatefulWidget {
  const BottomPageTwoHeader({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomPageTwoHeaderState();
}

class _BottomPageTwoHeaderState extends ConsumerState<BottomPageTwoHeader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        final startDate = ref.read(provFGoal).start;
        final goalDate = ref.read(provFGoal).goalDate;
        if (goalDate != null) {
          int? dateDiff = daysBetween(startDate, goalDate) + 1;
          ref.read(provFGoal).setDateDiff(dateDiff);
          final term = ref.read(provFGoal).periodTerm;
          if (dateDiff >= 365 && term == 'ALY') {
            ref.read(provFGoal).setPeriodTerm("ALY");
          } else if (dateDiff >= 30 && term == 'MLY') {
            ref.read(provFGoal).setPeriodTerm("MLY");
          } else if (dateDiff >= 7 && term == 'WLY') {
            ref.read(provFGoal).setPeriodTerm("WLY");
          } else {
            ref.read(provFGoal).setPeriodTerm("DLY");
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final periodTerm = ref.watch(provFGoal).periodTerm;
    final dateDiff = ref.watch(provFGoal).dateDiff;

    return SizedBox(
      height: 60,
      child: Row(
        children: [
          if (dateDiff == null || dateDiff >= 365) ...[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(provFGoal).setPeriodTerm("ALY");
                  ref.read(provFGoal).setIsCheck(true);
                },
                child: Text(
                  "ปีละ",
                  style: MyTheme.whiteTextTheme.bodyText1!.merge(
                    TextStyle(
                      color: periodTerm == 'ALY'
                          ? MyTheme.primaryMajor
                          : const Color.fromARGB(255, 44, 44, 44)
                              .withOpacity(0.4),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          if (dateDiff == null || dateDiff >= 30) ...[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(provFGoal).setPeriodTerm("MLY");
                  ref.read(provFGoal).setIsCheck(true);
                },
                child: Text(
                  "เดือนละ",
                  style: MyTheme.whiteTextTheme.bodyText1!.merge(
                    TextStyle(
                      color: periodTerm == 'MLY'
                          ? MyTheme.primaryMajor
                          : const Color.fromARGB(255, 44, 44, 44)
                              .withOpacity(0.4),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          if (dateDiff == null || dateDiff >= 7) ...[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(provFGoal).setPeriodTerm("WLY");
                  ref.read(provFGoal).setIsCheck(true);
                },
                child: Text(
                  "สัปดาห์ละ",
                  style: MyTheme.whiteTextTheme.bodyText1!.merge(
                    TextStyle(
                      color: periodTerm == 'WLY'
                          ? MyTheme.primaryMajor
                          : const Color.fromARGB(255, 44, 44, 44)
                              .withOpacity(0.4),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(provFGoal).setPeriodTerm("DLY");
                ref.read(provFGoal).setIsCheck(true);
              },
              child: Text(
                "วันละ",
                style: MyTheme.whiteTextTheme.bodyText1!.merge(
                  TextStyle(
                    color: periodTerm == 'DLY'
                        ? MyTheme.primaryMajor
                        : const Color.fromARGB(255, 44, 44, 44)
                            .withOpacity(0.4),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomPageTwoBody extends ConsumerStatefulWidget {
  const BottomPageTwoBody({Key? key}) : super(key: key);

  @override
  BottomPageTwoBodyState createState() => BottomPageTwoBodyState();
}

class BottomPageTwoBodyState extends ConsumerState<BottomPageTwoBody> {
  // final _controller = TextEditingController();

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final progPerPeriod = ref.watch(provFGoal.select((e) => e.progPerPeriod));
    final perdiodTerm = ref.watch(provFGoal.select((e) => e.periodTerm));
    final goal = ref.watch(provFGoal).goal;
    final startDate = ref.watch(provFGoal).start;
    final goalDate = ref.watch(provFGoal).goalDate;
    final isCheck = ref.watch(provFGoal).isCheck;

    int? dateDiff;

    if (goalDate != null) {
      dateDiff = daysBetween(startDate, goalDate) + 1;
    }

    if (perdiodTerm == "ALY") {
      double? atleast;
      if (dateDiff != null) {
        atleast = (goal / (dateDiff / 365).ceil()).ceilToDouble();
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            TextFormField(
              onChanged: (e) =>
                  ref.read(provFGoal).setProgPerPeriod(double.tryParse(e) ?? 0),
              // controller: _controller,
              initialValue:
                  progPerPeriod == 0 ? null : progPerPeriod.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(6),
                labelText: atleast != null
                    ? 'อย่างน้อย ${HelperNumber.format(atleast)} บ./ปี'
                    : 'จำนวนเงินต่อปี',
                labelStyle: MyTheme.whiteTextTheme.bodyText1!.merge(
                  TextStyle(
                    color: isCheck == false
                        ? Colors.red
                        : const Color.fromARGB(255, 44, 44, 44)
                            .withOpacity(0.2),
                  ),
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color: MyTheme.primaryMajor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color:
                        const Color.fromARGB(255, 44, 44, 44).withOpacity(0.2),
                  ),
                ),
                fillColor:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                filled: true,
              ),
              style: MyTheme.whiteTextTheme.headline3!.merge(
                TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
    if (perdiodTerm == "MLY") {
      double? atleast;
      if (dateDiff != null) {
        atleast = (goal / (dateDiff / 30).ceil()).ceilToDouble();
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            TextFormField(
              onChanged: (e) =>
                  ref.read(provFGoal).setProgPerPeriod(double.tryParse(e) ?? 0),
              // controller: _controller,
              initialValue:
                  progPerPeriod == 0 ? null : progPerPeriod.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(6),
                labelText: atleast != null
                    ? 'อย่างน้อย ${HelperNumber.format(atleast)} บ./เดือน'
                    : 'จำนวนเงินต่อเดือน',
                labelStyle: MyTheme.whiteTextTheme.bodyText1!.merge(
                  TextStyle(
                    color: isCheck == false
                        ? Colors.red
                        : const Color.fromARGB(255, 44, 44, 44)
                            .withOpacity(0.2),
                  ),
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color: MyTheme.primaryMajor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color:
                        const Color.fromARGB(255, 44, 44, 44).withOpacity(0.2),
                  ),
                ),
                fillColor:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                filled: true,
              ),
              style: MyTheme.whiteTextTheme.headline3!.merge(
                TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
    if (perdiodTerm == "WLY") {
      double? atleast;
      if (dateDiff != null) {
        atleast = (goal / (dateDiff / 7).ceil()).ceilToDouble();
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            TextFormField(
              onChanged: (e) =>
                  ref.read(provFGoal).setProgPerPeriod(double.tryParse(e) ?? 0),
              // controller: _controller,
              initialValue:
                  progPerPeriod == 0 ? null : progPerPeriod.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(6),
                labelText: atleast != null
                    ? 'อย่างน้อย ${HelperNumber.format(atleast)} บ./สัปดาห์'
                    : 'จำนวนเงินต่อสัปดาห์',
                labelStyle: MyTheme.whiteTextTheme.bodyText1!.merge(
                  TextStyle(
                    color: isCheck == false
                        ? Colors.red
                        : const Color.fromARGB(255, 44, 44, 44)
                            .withOpacity(0.2),
                  ),
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color: MyTheme.primaryMajor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color:
                        const Color.fromARGB(255, 44, 44, 44).withOpacity(0.2),
                  ),
                ),
                fillColor:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                filled: true,
              ),
              style: MyTheme.whiteTextTheme.headline3!.merge(
                TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
    if (perdiodTerm == "DLY") {
      double? atleast;
      if (dateDiff != null) {
        atleast = (goal / dateDiff).ceilToDouble();
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            TextFormField(
              onChanged: (e) =>
                  ref.read(provFGoal).setProgPerPeriod(double.tryParse(e) ?? 0),
              // controller: _controller,
              initialValue:
                  progPerPeriod == 0 ? null : progPerPeriod.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(6),
                labelText: atleast != null
                    ? 'อย่างน้อย ${HelperNumber.format(atleast)} บ./วัน'
                    : 'จำนวนเงินต่อวัน',
                labelStyle: MyTheme.whiteTextTheme.bodyText1!.merge(
                  TextStyle(
                    color: isCheck == false
                        ? Colors.red
                        : const Color.fromARGB(255, 44, 44, 44)
                            .withOpacity(0.2),
                  ),
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color: MyTheme.primaryMajor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color:
                        const Color.fromARGB(255, 44, 44, 44).withOpacity(0.2),
                  ),
                ),
                fillColor:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                filled: true,
              ),
              style: MyTheme.whiteTextTheme.headline3!.merge(
                TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

class Botton extends ConsumerWidget {
  const Botton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMainForm = ref.watch(provFGoal.select((value) => value.isMainForm));

    return SizedBox(
      height: 50,
      width: 360,
      child: RaisedButton(
          color: ref.watch(provFGoal).progPerPeriod == 0
              ? Color(0xFFECECEC)
              : Color(0xFF5236FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Text("บันทึก",
              style: MyTheme.whiteTextTheme.headline3!.merge(
                TextStyle(
                    color: ref.watch(provFGoal).progPerPeriod == 0
                        ? Color(0xFF565656)
                        : Colors.white),
              )),
          onPressed: () {
            if (ref.watch(provFGoal).progPerPeriod == 0) {
            } else {
              if (!isMainForm) {
                final startDate = ref.read(provFGoal).start;
                final goalDate = ref.read(provFGoal).goalDate;
                final goal = ref.read(provFGoal).goal;
                final term = ref.read(provFGoal).periodTerm;
                final prog = ref.read(provFGoal).progPerPeriod;

                if (goalDate != null) {
                  final dateDiff = daysBetween(startDate, goalDate) + 1;
                  if (term == 'ALY') {
                    final atleast =
                        (goal / (dateDiff / 365).ceil()).ceilToDouble();
                    if (prog < atleast) {
                      ref.read(provFGoal).setIsCheck(false);
                    } else {
                      ref.read(provFGoal).setIsCheck(true);
                      ref.read(provFGoal).setIsMainForm(true);
                    }
                  } else if (term == 'MLY') {
                    final atleast =
                        (goal / (dateDiff / 30).ceil()).ceilToDouble();
                    if (prog < atleast) {
                      ref.read(provFGoal).setIsCheck(false);
                    } else {
                      ref.read(provFGoal).setIsCheck(true);
                      ref.read(provFGoal).setIsMainForm(true);
                    }
                    ;
                  } else if (term == 'WLY') {
                    final atleast =
                        (goal / (dateDiff / 7).ceil()).ceilToDouble();
                    if (prog < atleast) {
                      ref.read(provFGoal).setIsCheck(false);
                    } else {
                      ref.read(provFGoal).setIsCheck(true);
                      ref.read(provFGoal).setIsMainForm(true);
                    }
                  } else {
                    final atleast = (goal / dateDiff).ceilToDouble();
                    if (prog < atleast) {
                      ref.read(provFGoal).setIsCheck(false);
                    } else {
                      ref.read(provFGoal).setIsCheck(true);
                      ref.read(provFGoal).setIsMainForm(true);
                    }
                  }
                } else
                  ref.read(provFGoal).setIsMainForm(true);
              }
            }
          }),
    );
  }
}

class ChooseIcons extends ConsumerWidget {
  const ChooseIcons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Icons = ref.watch(provFGoal.select((e) => e.icon));
    return Container(
      color: Colors.white,
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(icons.length, (i) {
          return Center(
            child: InkWell(
              child: CircleAvatar(
                  backgroundColor:
                      icons[i].toString() == ref.watch(provFGoal).icon
                          ? Color(0xFF5236FF)
                          : Color(0xFF5236FF).withOpacity(0.4),
                  radius: 40,
                  child: FittedBox(
                    child: Icon(
                      IconsFinance.getIconData(icons[i].toString()),
                      color: Colors.white,
                      size: 40,
                    ),
                  )),
              onTap: () {
                ref.read(provFGoal).setIcon(icons[i].toString());
                Navigator.pop(context);
              },
            ),
            // Icon(icons[i]),
          );
        }),
      ),
    );
  }
}
