import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:collection/collection.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/daily_flow/flow.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/ftype_coler.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/utility/progress.dart';
import '../daily_flow_page.dart';
import '../overview/daily_flow_overview_page.dart';

class DailyFlowCreatePage extends ConsumerWidget {
  const DailyFlowCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provDFlow);
    final currCat = ref.watch(provDFlow.select((e) => e.currCat));
    final isIncome = ref.watch(provDFlow.select((e) => e.colorBackground));
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 150,
                width: 500,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    colors: isIncome == 'income'
                        ? MyTheme.incomeBackground
                        : MyTheme.expenseBackground,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 35,
                      progressColor: Colors.white,
                      percent: HelperProgress.getPercent(
                        currCat.flows.map((e) => e.value).sum,
                        currCat.budgets.map((e) => e.total).sum,
                      ),
                      animation: true,
                      animationDuration: 1,
                      lineWidth: 6.5,
                      center: Icon(
                        HelperIcons.getIconData(currCat.icon),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            currCat.name,
                            style: MyTheme.whiteTextTheme.headline4!.merge(
                              TextStyle(color: Colors.white.withOpacity(.8)),
                            ),
                            maxLines: 1,
                          ),
                          Text(
                            '${isIncome == 'income' ? '+' : '-'}${_loopFlow(currCat.flows)} บ.',
                            style: MyTheme.whiteTextTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.separated(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (_, i) => const SizedBox(height: 10),
                    itemCount: currCat.flows.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          final read = ref.read(provDFlow);
                          read.setFlowId(currCat.flows[index].id);
                          read.setFlowName(currCat.flows[index].name);
                          read.setFlowValue(currCat.flows[index].value);
                          read.setFlowMethod(
                            currCat.flows[index].method.id,
                          );
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) =>
                                const Calculator(isAdd: false),
                          );
                        },
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: MyTheme.dropShadow,
                                blurRadius: 1,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Slidable(
                            key: Key(currCat.flows[index].id),
                            endActionPane: ActionPane(
                              extentRatio: 0.25,
                              motion: const BehindMotion(),
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        useRootNavigator: false,
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              'ท่านยืนยันที่จะลบหรือไม่?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('ยกเลิก'),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                            TextButton(
                                              child: const Text('ยืนยัน'),
                                              onPressed: () async {
                                                final flowId = await ref
                                                    .read(apiProvider)
                                                    .deleteFlow(currCat
                                                        .flows[index].id);
                                                if (flowId != '') {
                                                  ref
                                                      .read(provDFlow)
                                                      .removeFlow(flowId);
                                                  ref
                                                      .read(provDFlow)
                                                      .setNeedFetchAPI();
                                                  ref
                                                      .read(provOverFlow)
                                                      .setNeedFetchAPI();
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: MyTheme.expenseBackground,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'ลบ',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    fit: FlexFit.tight,
                                    child: Container(
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: HelperColor.getFtColor(
                                          currCat.ftype,
                                          0,
                                        ),
                                      ),
                                      child: Icon(
                                        HelperIcons.getIconData(currCat.icon),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              currCat.flows[index].name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 10,
                                              children: [
                                                Icon(
                                                  getIcon(currCat
                                                      .flows[index].method.id),
                                                  size: 15,
                                                  color: HelperColor.getFtColor(
                                                    currCat.ftype,
                                                    0,
                                                  ),
                                                ),
                                                Text(
                                                  getMethod(currCat
                                                      .flows[index].method.id),
                                                  style: TextStyle(
                                                    color:
                                                        HelperColor.getFtColor(
                                                      currCat.ftype,
                                                      0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${currCat.flows[index].value.toString()} บ.',
                                          style: MyTheme.textTheme.headline2!
                                              .merge(
                                            TextStyle(
                                              color: HelperColor.getFtColor(
                                                currCat.ftype,
                                                0,
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: 100,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
                color: Colors.white,
                child: TextButton.icon(
                  label: Text(
                    'เพิ่มรายการใหม่ ',
                    style: MyTheme.whiteTextTheme.headline3!.merge(
                      TextStyle(
                        color: ref.watch(provDFlow.select(
                                (value) => value.colorBackground == 'income'))
                            ? MyTheme.positiveMajor
                            : MyTheme.negativeMajor,
                      ),
                    ),
                  ),
                  icon: Icon(
                    Icons.add,
                    color: ref.watch(provDFlow.select(
                            (value) => value.colorBackground == 'income'))
                        ? MyTheme.positiveMajor
                        : MyTheme.negativeMajor,
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: ref.watch(provDFlow.select(
                            (value) => value.colorBackground == 'income'))
                        ? MyTheme.positiveMinor
                        : MyTheme.negativeMinor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    minimumSize: const Size(double.infinity, double.infinity),
                  ),
                  onPressed: () {
                    ref.read(provDFlow).setFlowId('');
                    ref.read(provDFlow).setFlowName(currCat.name);
                    ref.read(provDFlow).setFlowValue(0);
                    ref.read(provDFlow).setFlowMethod(2);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => const Calculator(isAdd: true),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData getIcon(int value) {
    if (value == 2) return FontAwesomeIcons.moneyBill;
    if (value == 3) return FontAwesomeIcons.exchangeAlt;
    return FontAwesomeIcons.creditCard;
  }

  String getMethod(int value) {
    if (value == 2) return 'เงินสด';
    if (value == 3) return 'โอน';
    return 'บัตรเครดิต';
  }
}

String _loopFlow(List<DFlowFlow> value) {
  double sum = 0;
  for (var e in value) {
    sum += e.value;
  }
  return sum.toString();
}

class Calculator extends ConsumerWidget {
  const Calculator({required this.isAdd, Key? key}) : super(key: key);
  final bool isAdd;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 30,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            // autofocus: true,
            initialValue: ref.watch(provDFlow).flowName,

            onChanged: (e) {
              ref.read(provDFlow).setFlowName(e);
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: ref.watch(provDFlow).currCat.name,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 7,
                child: TextFormField(
                  // autofocus: true,
                  initialValue: ref.watch(provDFlow).flowValue == 0
                      ? null
                      : ref.watch(provDFlow).flowValue.toString(),

                  keyboardType: TextInputType.number,
                  onChanged: (e) {
                    ref.read(provDFlow).setFlowValue(double.tryParse(e) ?? 0);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    // hintText: ref.watch(provDFlow).flowName,
                    hintText: 'โปรดกรอกจำนวนเงิน',
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: DropdownButton<int>(
                  style: MyTheme.textTheme.bodyText1!.merge(
                    const TextStyle(color: Colors.black),
                  ),
                  value: ref.watch(provDFlow).flowMethod,
                  icon: const Icon(Icons.arrow_downward),
                  onChanged: (int? e) {
                    ref.read(provDFlow).setFlowMethod(e!);
                  },
                  items: <String>['เงินสด', 'โอน', 'บัตรเครดิต']
                      .map<DropdownMenuItem<int>>((String value) {
                    return DropdownMenuItem<int>(
                      value: _returnType(value),
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      'ยกเลิก',
                      style: MyTheme.whiteTextTheme.headline3,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (ref.watch(provDFlow).flowValue == 0) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          title: Text(
                            'โปรดกรอกจำนวนเงิน',
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    );
                    return;
                  }
                  if (isAdd) {
                    final flow = await ref.read(apiProvider).addFlow(
                          ref.read(provOverFlow).dfId,
                          ref.read(provDFlow).currCat.id,
                          ref.read(provDFlow).flowName,
                          ref.read(provDFlow).flowValue,
                          ref.read(provDFlow).flowMethod,
                        );

                    if (flow.id != '') {
                      ref.read(provDFlow).addFlow(flow);
                      ref.read(provDFlow).setNeedFetchAPI();
                      ref.read(provOverFlow).setNeedFetchAPI();
                      ref.refresh(apiDateChange);
                      AutoRouter.of(context).pop();
                    }
                  } else {
                    final flow = await ref.read(apiProvider).editFlow(
                          ref.read(provDFlow).flowId,
                          ref.read(provDFlow).flowName,
                          ref.read(provDFlow).flowValue,
                          ref.read(provDFlow).flowMethod,
                        );
                    if (flow.id != '') {
                      ref.read(provDFlow).editFlow(flow);
                      ref.read(provDFlow).setNeedFetchAPI();
                      ref.read(provOverFlow).setNeedFetchAPI();
                      ref.refresh(apiDateChange);
                      AutoRouter.of(context).pop();
                    }
                  }
                },
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Text(
                      'ยืนยัน',
                      style: MyTheme.whiteTextTheme.headline3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  int _returnType(String value) {
    if (value == 'เงินสด') return 2;
    if (value == 'โอน') return 3;
    return 4;
  }
}
