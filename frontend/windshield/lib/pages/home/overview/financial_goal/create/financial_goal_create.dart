import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:windshield/styles/theme.dart';
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
    return Column(
      children: [
        SizedBox(
          height: 450,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
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
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      initialValue: goal == 0 ? '' : goal.toString(),
                      keyboardType: TextInputType.number,
                      // inputFormatters: <TextInputFormatter>[
                      //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      // ],
                      decoration: InputDecoration.collapsed(
                        hintText: 'จำนวนเงิน.',
                        hintStyle: MyTheme.whiteTextTheme.headline3!.merge(
                          TextStyle(
                            color: const Color.fromARGB(255, 44, 44, 44)
                                .withOpacity(0.2),
                          ),
                        ),
                      ),
                      onChanged: (e) {
                        ref.read(provFGoal).setGoal(double.tryParse(e) ?? 0);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                                    if (daysBetween(e, goalDate) < 1) {
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
                  onTap: () => ref.read(provFGoal).setIsMainForm(false),
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
                                  } else if (periodTerm == 'MLY') {
                                    atleast = goal / (dateDiff / 30).ceil();
                                  } else if (periodTerm == 'WLY') {
                                    atleast = goal / (dateDiff / 7).ceil();
                                  } else {
                                    atleast = goal / dateDiff;
                                  }
                                  print(progPerPeriod);
                                  print(atleast);
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
        SizedBox(
          height: 50,
          width: 300,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Text("บันทึก",
                  style: MyTheme.whiteTextTheme.headline3!.merge(
                    TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  )),
              onPressed: () {
                // print(start);
                // print(goalDate);
                // print(getCalDay(goalDate, start));
                // AutoRouter.of(context).pop();
              }),
        )
      ],
    );
  }
}

class ShowBottomPageTwo extends ConsumerWidget {
  const ShowBottomPageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: const [
        BottomPageTwoHeader(),
        BottomPageTwoBody(),
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
        ref.read(provFGoal).setPeriodTerm("DLY");
        if (goalDate != null) {
          int? dateDiff = daysBetween(startDate, goalDate) + 1;
          ref.read(provFGoal).setDateDiff(dateDiff);
          if (dateDiff >= 365) return ref.read(provFGoal).setPeriodTerm("ALY");
          if (dateDiff >= 30) return ref.read(provFGoal).setPeriodTerm("MLY");
          if (dateDiff >= 7) return ref.read(provFGoal).setPeriodTerm("WLY");
          return ref.read(provFGoal).setPeriodTerm("DLY");
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
          if (dateDiff != null && dateDiff >= 365) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => ref.read(provFGoal).setPeriodTerm("ALY"),
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
          if (dateDiff != null && dateDiff >= 30) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => ref.read(provFGoal).setPeriodTerm("MLY"),
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
          if (dateDiff != null && dateDiff >= 7) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => ref.read(provFGoal).setPeriodTerm("WLY"),
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
              onTap: () => ref.read(provFGoal).setPeriodTerm("DLY"),
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

    int? dateDiff;

    if (goalDate != null) {
      dateDiff = daysBetween(startDate, goalDate) + 1;
    }

    if (perdiodTerm == "ALY") {
      double? atleast;
      if (dateDiff != null) atleast = goal / (dateDiff / 365).ceil();
      return Padding(
        padding: const EdgeInsets.all(10),
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
                hintText: atleast != null
                    ? 'อย่างน้อย $atleast บ./ปี'
                    : 'จำนวนเงินต่อปี',
                hintStyle: MyTheme.whiteTextTheme.headline4!.merge(
                  TextStyle(
                    color:
                        const Color.fromARGB(255, 44, 44, 44).withOpacity(0.2),
                  ),
                ),
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
            ),
          ],
        ),
      );
    }
    if (perdiodTerm == "MLY") {
      double? atleast;
      if (dateDiff != null) atleast = goal / (dateDiff / 30).ceil();
      return Padding(
        padding: const EdgeInsets.all(10),
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
                hintText: atleast != null
                    ? 'อย่างน้อย $atleast บ./เดือน'
                    : 'จำนวนเงินต่อเดือน',
                hintStyle: MyTheme.whiteTextTheme.headline4!.merge(
                  TextStyle(
                      color: const Color.fromARGB(255, 44, 44, 44)
                          .withOpacity(0.2)),
                ),
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
            ),
          ],
        ),
      );
    }
    if (perdiodTerm == "WLY") {
      double? atleast;
      if (dateDiff != null) atleast = goal / (dateDiff / 7).ceil();
      return Padding(
        padding: const EdgeInsets.all(10),
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
                hintText: atleast != null
                    ? 'อย่างน้อย $atleast บ./สัปดาห์'
                    : 'จำนวนเงินต่อสัปดาห์',
                hintStyle: MyTheme.whiteTextTheme.headline4!.merge(
                  TextStyle(
                      color: const Color.fromARGB(255, 44, 44, 44)
                          .withOpacity(0.2)),
                ),
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
            ),
          ],
        ),
      );
    }
    if (perdiodTerm == "DLY") {
      double? atleast;
      if (dateDiff != null) atleast = goal / dateDiff;
      return Padding(
        padding: const EdgeInsets.all(10),
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
                hintText: atleast != null
                    ? 'อย่างน้อย $atleast บ./วัน'
                    : 'จำนวนเงินต่อวัน',
                hintStyle: MyTheme.whiteTextTheme.headline4!.merge(
                  TextStyle(
                      color: const Color.fromARGB(255, 44, 44, 44)
                          .withOpacity(0.2)),
                ),
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
