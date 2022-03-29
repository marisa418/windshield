import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:windshield/main.dart';
import 'package:windshield/models/daily_flow/flow.dart';
import 'package:windshield/pages/home/overview/statement/create/date.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';

class DailyFlowCreatePage extends ConsumerWidget {
  const DailyFlowCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currCat = ref.watch(provDFlow).currCat;

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 150,
            width: 500,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                colors: ref.watch(provDFlow
                        .select((value) => value.colorBackground == 'income'))
                    ? MyTheme.incomeBackground
                    : MyTheme.expenseBackground,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: CircularPercentIndicator(
                    radius: 35,
                    progressColor: Colors.white,
                    percent: 0.5,
                    animation: true,
                    animationDuration: 2000,
                    lineWidth: 6.5,
                    center: Icon(
                      HelperIcons.getIconData(currCat.icon),
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        Text(
                          '   ${currCat.name}',
                          style: MyTheme.whiteTextTheme.headline4,
                        ),
                        Text(
                          _loopFlow(currCat.flows),
                          style: MyTheme.whiteTextTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 25,
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const ScrollPhysics(),
                    itemCount: currCat.flows.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  25.0, 10.0, 10.0, 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: ref.watch(provDFlow.select(
                                            (value) =>
                                                value.colorBackground ==
                                                'income'))
                                        ? MyTheme.positiveMajor
                                        : MyTheme.negativeMajor,
                                    radius: 35,
                                    child: Icon(
                                      HelperIcons.getIconData(currCat.icon),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    " ${currCat.flows[index].name}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Icon(
                                                    HelperIcons.getIconData(
                                                        currCat.icon),
                                                    color: Colors.green,
                                                    size: 18),
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${currCat.flows[index].method.name}",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text('${currCat.flows[index].value}',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('Edit'),
                                  onPressed: () {
                                    ref
                                        .read(provDFlow)
                                        .setFlowId(currCat.flows[index].id);
                                    ref
                                        .read(provDFlow)
                                        .setFlowName(currCat.flows[index].name);
                                    ref.read(provDFlow).setFlowValue(
                                        currCat.flows[index].value);
                                    ref.read(provDFlow).setFlowMethod(
                                        currCat.flows[index].method.id);

                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          Calculator(isAdd: false),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () async {
                                    final flowId = await ref
                                        .read(apiProvider)
                                        .deleteFlow(currCat.flows[index].id);
                                    if (flowId != '') {
                                      ref.read(provDFlow).removeFlow(flowId);
                                      ref.read(provDFlow).setNeedFetchAPI();
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    shrinkWrap: true,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 85,
            width: 500,
            color: Colors.white,
            child: SizedBox(
              height: 80,
              child: Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  label: Text(
                    'เพิ่มรายการใหม่ ',
                    style: MyTheme.whiteTextTheme.headline3,
                  ),
                  icon: Icon(
                    Icons.add,
                    color: ref.watch(provDFlow.select(
                            (value) => value.colorBackground == 'income'))
                        ? MyTheme.positiveMajor
                        : MyTheme.negativeMajor,
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: MyTheme.primaryMajor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                  ),
                  onPressed: () {
                    ref.read(provDFlow).setFlowId('');
                    ref.read(provDFlow).setFlowName(currCat.name);
                    ref.read(provDFlow).setFlowValue(0);
                    ref.read(provDFlow).setFlowMethod(2);
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Calculator(isAdd: true),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
              border: OutlineInputBorder(),
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
                  initialValue: ref.watch(provDFlow).flowValue.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (e) {
                    ref.read(provDFlow).setFlowValue(double.tryParse(e) ?? 0);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: ref.watch(provDFlow).flowName,
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
                  if (isAdd) {
                    final flow = await ref.read(apiProvider).addFlow(
                          ref.read(provDFlow).dfId,
                          ref.read(provDFlow).currCat.id,
                          ref.read(provDFlow).flowName,
                          ref.read(provDFlow).flowValue,
                          ref.read(provDFlow).flowMethod,
                        );
                    if (flow.id != '') {
                      ref.read(provDFlow).addFlow(flow);
                      ref.read(provDFlow).setNeedFetchAPI();
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
