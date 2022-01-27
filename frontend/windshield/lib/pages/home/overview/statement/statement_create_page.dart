import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:windshield/main.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/models/category.dart';

class StatementCreatePage extends ConsumerWidget {
  const StatementCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IndexedStack(
      index: ref.watch(statementCreateProvider).selectedPage,
      children: const [
        DatePage(),
        CategoryPage(),
      ],
    );
  }
}

class DatePage extends ConsumerWidget {
  const DatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Palette.kToDark.shade200,
          ],
        ),
      ),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Text(
              'ระยะเวลา ${ref.watch(statementCreateProvider).getDateDiff().toString()} วัน',
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .merge(const TextStyle(color: Colors.white)),
            ),
          ),
          const Flexible(
            flex: 9,
            child: DatePicker(),
          ),
        ],
      ),
    );
  }
}

class DatePicker extends ConsumerWidget {
  const DatePicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SfDateRangePicker(
      selectionMode: DateRangePickerSelectionMode.range,
      selectionRadius: 20,
      enablePastDates: false,
      allowViewNavigation: false,
      headerHeight: 100,
      headerStyle: DateRangePickerHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: Theme.of(context)
            .textTheme
            .headline1!
            .merge(const TextStyle(color: Colors.white)),
      ),
      selectionTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
            TextStyle(fontSize: 27, color: Palette.kToDark.shade500),
          ),
      rangeTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
            const TextStyle(fontSize: 27, color: Colors.white70),
          ),
      startRangeSelectionColor: Colors.white,
      endRangeSelectionColor: Colors.white,
      rangeSelectionColor: Colors.white.withOpacity(.2),
      monthViewSettings: DateRangePickerMonthViewSettings(
        // viewHeaderHeight: 100,
        showTrailingAndLeadingDates: true,
        dayFormat: 'EEE',

        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: Theme.of(context).textTheme.headline2!.merge(
                const TextStyle(color: Colors.white, fontSize: 15),
              ),
        ),
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        textStyle: Theme.of(context).textTheme.bodyText1!.merge(
              const TextStyle(color: Colors.white, fontSize: 24),
            ),
        todayTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
              const TextStyle(color: Colors.white, fontSize: 24),
            ),
        todayCellDecoration: const ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.transparent,
        ),
        disabledDatesTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
              const TextStyle(fontSize: 18, color: Colors.grey),
            ),
        trailingDatesTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
              const TextStyle(fontSize: 20, color: Colors.white70),
            ),
        leadingDatesTextStyle: Theme.of(context).textTheme.bodyText1!.merge(
              const TextStyle(fontSize: 20, color: Colors.white70),
            ),
      ),
      showActionButtons: true,
      showTodayButton: true,
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        if (args.value is PickerDateRange) {
          ref.read(statementCreateProvider).setStartDate(
              DateFormat('yyyy-MM-dd').format(args.value.startDate));
          ref.read(statementCreateProvider).setEndDate(DateFormat('yyyy-MM-dd')
              .format(args.value.endDate ?? args.value.startDate));
        }
      },
      confirmText: 'บันทึก',
      cancelText: 'ย้อนกลับ',
      onSubmit: (value) {
        if (ref.read(statementCreateProvider).getDateDiff() <= 21) {
          print('LESS THAN 21');
        } else {
          ref.read(statementCreateProvider).setSelectedPage(1);
        }
      },
      onCancel: () {
        AutoRouter.of(context).pop();
      },
    );
  }
}

class CategoryPage extends ConsumerWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryApi = ref.watch(categoryApiProvider);
    final categoryType = ref.watch(statementCreateProvider);
    final List<Category> income1 = [];
    final List<Category> income2 = [];
    final List<Category> income3 = [];
    for (var item in categoryType.category) {
      if (item.ftype == '1') {
        income1.add(item);
      } else if (item.ftype == '2') {
        income2.add(item);
      } else if (item.ftype == '3') {
        income3.add(item);
      }
    }

    return categoryApi.when(
      error: (error, stackTrace) => Text('Error : $error'),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 450,
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.center,
                  // textDirection: TextDirection.LTR,
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Theme.of(context).primaryColor,
                                Palette.kToDark.shade300,
                              ]),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        // margin: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    // const SizedBox(height: 30),
                    CategoryType('รายรับจากการทำงาน', income1, context),
                    // const SizedBox(height: 30),
                    CategoryType('รายรับจากสินทรัพย์', income2, context),
                    // const SizedBox(height: 30),
                    CategoryType('รายรับอื่นๆ', income3, context),
                    SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(statementCreateProvider)
                                  .setSelectedPage(0);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            child: SizedBox(
                              width: 125,
                              child: Text(
                                'ย้อนกลับ',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .merge(
                                      TextStyle(color: Colors.white),
                                    ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final res = await ref
                                  .read(apiProvider)
                                  .createStatement(categoryType.startDate,
                                      categoryType.endDate);
                              if (res) {
                                AutoRouter.of(context)
                                    .replace(StatementRoute());
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            child: SizedBox(
                              width: 125,
                              child: Text(
                                'บันทึก',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .merge(
                                      TextStyle(color: Colors.white),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CategoryType extends ConsumerWidget {
  const CategoryType(this.categoryType, this.category, this.context, {Key? key})
      : super(key: key);
  final List<Category> category;
  final String categoryType;
  final BuildContext context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      // color: Colors.green,
      width: MediaQuery.of(context).size.width,
      // alignment: Alignment.topLeft,
      child: Container(
        // color: Colors.green,
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              categoryType,
              style: Theme.of(context).textTheme.bodyText1!.merge(
                    const TextStyle(fontSize: 20),
                  ),
              // textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            Wrap(
              // crossAxisAlignment: WrapCrossAlignment.start,
              // alignment: WrapAlignment.start,
              spacing: 30,
              children: _generateCat(category),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _generateCat(List<Category> obj) {
    var list = obj.map<List<Widget>>(
      (data) {
        var widgetList = <Widget>[];
        widgetList.add(
          SizedBox(
            width: 60,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    height: 50,
                    width: 50,
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white.withOpacity(0.1),
                    shape: CircleBorder(),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
              ],
            ),
          ),
        );
        return widgetList;
      },
    ).toList();
    var flat = list.expand((element) => element).toList();
    return flat;
  }
}
