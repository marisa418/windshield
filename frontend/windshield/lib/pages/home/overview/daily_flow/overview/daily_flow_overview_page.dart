import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:collection/collection.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:windshield/main.dart';
import 'package:windshield/providers/daily_flow_overview_provider.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/ftype_coler.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';
import '../์notification/noti_func.dart';
import '../์notification/noti_utility.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    bool _enable = false;

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
                            // final date = ref.read(provOverFlow).date;
                            final id = await ref
                                .read(apiProvider)
                                .getTodayDFId(picked);
                            ref.read(provOverFlow).setDfId(id);
                            ref.read(provOverFlow).setDate(picked);
                            ref.read(provOverFlow).setPageIdx(0);
                            AutoRouter.of(context).push(const DailyFlowRoute());
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
                      height: 70,
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
                    SizedBox(
                      height: 60,
                      width: 200,
                      child: Row(
                        children: const [
                          MyStatefulWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyStatefulWidget extends ConsumerStatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<MyStatefulWidget> {
  bool selected = false;
  String value = '';
  String toggle = '';

  @override
  void initState() {
    super.initState();

    /// Initialize Flutter Secure Storage
    const _storage = FlutterSecureStorage();

    /// Await your Future here (This function only called once after the layout is Complete)
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      value = await _storage.read(key: 'time') ?? '00:00';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: selected
            ? Matrix4.translationValues(0, 0, 0)
            : Matrix4.translationValues(140, 0, 0),
        height: 70,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          color: MyTheme.primaryMajor,
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.access_alarm_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'ตั้งเวลาเเจ้งเตือน',
                    style: MyTheme.whiteTextTheme.bodyText2,
                    minFontSize: 0,
                    maxLines: 1,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (ref.watch(provOverFlow).canSetTime) {
                        NotificationWeekAndTime? pickedSchedule =
                            await pickSchedule(context);

                        if (pickedSchedule != null) {
                          createReminderNotification(pickedSchedule);
                        }
                      }
                    },
                    child: AutoSizeText(
                      value,
                      minFontSize: 0,
                      maxLines: 1,
                      style: MyTheme.whiteTextTheme.headline4,
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SwitchButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchButton extends ConsumerStatefulWidget {
  const SwitchButton({Key? key}) : super(key: key);

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends ConsumerState<SwitchButton> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 60.0,
      height: 28.0,
      activeToggleColor: Colors.white,
      activeColor: Colors.yellow,
      valueFontSize: 20.0,
      toggleSize: 28.0,
      value: status,
      borderRadius: 30.0,
      padding: 3.0,
      showOnOff: false,
      onToggle: (val) {
        if (val) {
          ref.read(provOverFlow).setCanSetTime(true);
          setState(() {
            status = val;
          });
        } else {
          ref.read(provOverFlow).setCanSetTime(false);
          setState(() {
            status = val;
          });
        }
      },
    );
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
        height: 220,
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                ref.read(provOverFlow).setPageIdx(0);
                AutoRouter.of(context).push(const DailyFlowRoute());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('รายรับรวม ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  Text(
                    '+$incTotal บ.',
                    style: MyTheme.whiteTextTheme.headline2!.merge(
                      TextStyle(color: MyTheme.positiveMajor),
                    ),
                  ),
                  Container(
                    height: 75, //height of button
                    width: 160,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                    ),
                    //width of button
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(provOverFlow).setPageIdx(0);
                        AutoRouter.of(context).push(const DailyFlowRoute());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        elevation: 0.0,
                        //remove shadow on button
                        primary: MyTheme.positiveMajor,

                        textStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.all(6),

                        //shape: const CircleBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            HelperIcons.getIconData('hand-holding-usd'),
                            color: Colors.white,
                            size: 25,
                          ),
                          Expanded(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 8, 0, 0),
                                  child: Text(
                                    'บัญชีรายรับ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.none,
                                      color: Colors.white.withAlpha(200),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                AutoSizeText(
                                  incLength.toString() + ' รายการ',
                                  minFontSize: 0,
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
                  Container(
                    width: 160,
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontWeight: FontWeight.w700),
                        backgroundColor: MyTheme.positiveMinor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: () {
                        ref.read(provOverFlow).setPageIdx(0);
                        AutoRouter.of(context).pushAll(const [
                          DailyFlowRoute(),
                          SpeechToTextRoute(),
                        ]);
                      },
                      icon: Icon(
                        Icons.mic,
                        color: MyTheme.positiveMajor,
                        size: 15,
                      ),
                      label: Text('เพิ่มรายการใหม่ด้วยเสียง',
                          style: TextStyle(
                              color: MyTheme.positiveMajor, fontSize: 10)),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('รายจ่ายรวม ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  Text(
                    '-$expTotal บ.',
                    style: MyTheme.whiteTextTheme.headline2!.merge(
                      TextStyle(color: MyTheme.negativeMajor),
                    ),
                  ),
                  Container(
                    height: 75, //height of button
                    width: 160,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                    ), //width of button
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(provOverFlow).setPageIdx(1);
                        AutoRouter.of(context).push(const DailyFlowRoute());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0.0,
                        primary: MyTheme.negativeMajor,

                        textStyle: const TextStyle(fontSize: 15),
                        padding: const EdgeInsets.all(6),

                        //shape: const CircleBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.receipt,
                            color: Colors.white,
                            size: 30,
                          ),

                          // const Text(
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 8, 2, 0),
                                  child: Text(
                                    'บัญชีรายจ่าย',
                                    style: TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.none,
                                      color: Colors.white.withAlpha(200),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                AutoSizeText(
                                  expLength.toString() + ' รายการ',
                                  minFontSize: 0,
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
                  Container(
                    width: 160,
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontWeight: FontWeight.w700),
                        backgroundColor: MyTheme.negativeMinor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: () {
                        ref.read(provOverFlow).setPageIdx(1);
                        AutoRouter.of(context).pushAll(const [
                          DailyFlowRoute(),
                          SpeechToTextRoute(),
                        ]);
                      },
                      icon: Icon(
                        Icons.mic,
                        color: MyTheme.negativeMajor,
                        size: 15,
                      ),
                      label: Text('เพิ่มรายการใหม่ด้วยเสียง',
                          style: TextStyle(
                              color: MyTheme.negativeMajor, fontSize: 10)),
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
    final inc = ref.watch(provOverFlow).tdIncList;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รายรับวันนี้', style: MyTheme.textTheme.headline3),
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: MyTheme.primaryMajor),
                    backgroundColor: MyTheme.primaryMinor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    ref.read(provOverFlow).setPageIdx(0);
                    AutoRouter.of(context).push(const DailyFlowRoute());
                  },
                  child: const Text('ดูทั้งหมด')),
            ],
          ),
          if (inc.isEmpty) ...const [
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'ไม่มีรายการ',
                  style: TextStyle(color: Colors.grey),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รายรับวันนี้', style: MyTheme.textTheme.headline3),
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: MyTheme.primaryMajor),
                    backgroundColor: MyTheme.primaryMinor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    ref.read(provOverFlow).setPageIdx(1);
                    AutoRouter.of(context).push(const DailyFlowRoute());
                  },
                  child: const Text('ดูทั้งหมด')),
            ],
          ),
          if (exp.isEmpty) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'ไม่มีรายการ',
                  style: TextStyle(color: Colors.grey),
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
