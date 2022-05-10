import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/month_name_convertor.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';
import 'inc_exp_model.dart';
import 'inc_exp_provider.dart';

final provIncExp = ChangeNotifierProvider.autoDispose<IncExpProvider>(
    (ref) => IncExpProvider());

final apiIncExpGraph = FutureProvider.autoDispose<void>((ref) async {
  final type = ref.read(provIncExp).type;
  final graph = await ref.read(apiProvider).analIncExpGraph(type);
  ref.read(provIncExp).setGraph(graph);
});

final apiIncExp = FutureProvider.autoDispose<void>((ref) async {
  final range = ref.read(provIncExp).range;
  final data = await ref.read(apiProvider).analIncExp(range);
  ref.read(provIncExp).setIncExp(data);
});

class IncExpTab extends ConsumerWidget {
  const IncExpTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: const [
          Graph(),
          SizedBox(height: 15),
          Overview(),
        ],
      ),
    );
  }
}

class Graph extends ConsumerWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graph = ref.watch(provIncExp.select((e) => e.graph));
    final api = ref.watch(apiIncExpGraph);
    final type = ref.watch(provIncExp.select((e) => e.type));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              flex: 75,
              fit: FlexFit.tight,
              child: Text(
                'รายรับ-รายจ่ายย้อนหลัง',
                style: MyTheme.textTheme.headline4!.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Flexible(
              flex: 25,
              child: DropdownButtonFormField(
                isExpanded: true,
                style: MyTheme.textTheme.bodyText1!.merge(
                  const TextStyle(color: Colors.black),
                ),
                value: type,
                onChanged: (String? e) {
                  ref.read(provIncExp).setType(e!);
                  ref.refresh(apiIncExpGraph);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(.3),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(.3),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                items: ref
                    .watch(provIncExp.select((e) => e.typeList))
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: AutoSizeText(
                      () {
                        if (value.contains('daily')) {
                          return 'วัน';
                        } else if (value.contains('monthly')) {
                          return 'เดือน';
                        } else {
                          return 'ปี';
                        }
                      }(),
                      minFontSize: 0,
                      maxLines: 1,
                      style: MyTheme.textTheme.bodyText2,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 250,
          child: api.when(
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (_) => SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.top,
              ),
              series: <ChartSeries>[
                if (type.contains('daily')) ...[
                  StackedColumnSeries<IncExpGraph, String>(
                    dataSource: graph,
                    xValueMapper: (data, _) =>
                        DateFormat('d MMM').format(data.date!),
                    yValueMapper: (data, _) => data.income,
                    width: .3,
                    color: MyTheme.positiveMajor,
                    name: 'รายรับ',
                  ),
                  StackedColumnSeries<IncExpGraph, String>(
                    dataSource: graph,
                    xValueMapper: (data, _) =>
                        DateFormat('d MMM').format(data.date!),
                    yValueMapper: (data, _) => data.expense,
                    width: .3,
                    color: MyTheme.negativeMajor,
                    name: 'รายจ่าย',
                  ),
                ],
                if (type.contains('monthly')) ...[
                  StackedColumnSeries<IncExpGraph, String>(
                    dataSource: graph,
                    xValueMapper: (data, _) =>
                        '${HelperMonth.inttoMMM(data.month!)} ${data.year}',
                    yValueMapper: (data, _) => data.income,
                    width: .3,
                    color: MyTheme.positiveMajor,
                    name: 'รายรับ',
                  ),
                  StackedColumnSeries<IncExpGraph, String>(
                    dataSource: graph,
                    xValueMapper: (data, _) =>
                        '${HelperMonth.inttoMMM(data.month!)} ${data.year}',
                    yValueMapper: (data, _) => data.expense,
                    width: .3,
                    color: MyTheme.negativeMajor,
                    name: 'รายจ่าย',
                  ),
                ],
                if (type.contains('annually')) ...[
                  StackedColumnSeries<IncExpGraph, String>(
                    dataSource: graph,
                    xValueMapper: (data, _) => '${data.year}',
                    yValueMapper: (data, _) => data.income,
                    width: .3,
                    color: MyTheme.positiveMajor,
                    name: 'รายรับ',
                  ),
                  StackedColumnSeries<IncExpGraph, String>(
                    dataSource: graph,
                    xValueMapper: (data, _) => '${data.year}',
                    yValueMapper: (data, _) => data.expense,
                    width: .3,
                    color: MyTheme.negativeMajor,
                    name: 'รายจ่าย',
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Overview extends ConsumerWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incExp = ref.watch(provIncExp.select((e) => e.incExp));
    final api = ref.watch(apiIncExp);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'เฉลี่ยย้อนหลัง',
              style: MyTheme.textTheme.headline3!.merge(
                const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700, color: MyTheme.primaryMajor),
                backgroundColor: MyTheme.primaryMinor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => SizedBox(
                    width: 100,
                    child: AlertDialog(
                      insetPadding: const EdgeInsets.all(120),
                      content: TextFormField(
                        initialValue: ref
                            .watch(provIncExp.select((e) => e.range))
                            .toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (e) =>
                            ref.read(provIncExp).setRange(int.tryParse(e) ?? 0),
                        decoration: const InputDecoration(
                          labelText: 'จำนวนวัน',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                );
                ref.refresh(apiIncExp);
              },
              child: Text(
                '${ref.watch(provIncExp.select((e) => e.range))} วัน',
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        api.when(
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (_) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ค่าใช้จ่าย',
                    style: MyTheme.textTheme.headline4,
                  ),
                  Text(
                    '${HelperNumber.format(incExp.avgExp)} บ.',
                    style: MyTheme.textTheme.headline4!.merge(
                      TextStyle(
                        color: MyTheme.negativeMajor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Flexible(
                    flex: 45,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รายจ่ายไม่คงที่',
                          style: MyTheme.textTheme.bodyText1,
                        ),
                        Text(
                          '${HelperNumber.format(incExp.avgExpInconsist)} บ.',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.expenseInconsist[0]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${HelperNumber.format(HelperProgress.getPercent(
                                incExp.avgExpInconsist,
                                incExp.avgExp,
                              ) * 100)}%',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.expenseInconsist[0]),
                          ),
                        ),
                        LinearPercentIndicator(
                          lineHeight: 16.0,
                          percent: HelperProgress.getPercent(
                            incExp.avgExpInconsist,
                            incExp.avgExp,
                          ),
                          padding: const EdgeInsets.all(0),
                          animation: true,
                          animationDuration: 2500,
                          backgroundColor: Colors.grey[300],
                          progressColor: MyTheme.expenseInconsist[0],
                          barRadius: const Radius.circular(20),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 45,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รายจ่ายคงที่',
                          style: MyTheme.textTheme.bodyText1,
                        ),
                        Text(
                          '${HelperNumber.format(incExp.avgExpConsist)} บ.',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.expenseConsist[0]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${HelperNumber.format(HelperProgress.getPercent(
                                incExp.avgExpConsist,
                                incExp.avgExp,
                              ) * 100)}%',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.expenseConsist[0]),
                          ),
                        ),
                        LinearPercentIndicator(
                          lineHeight: 16.0,
                          percent: HelperProgress.getPercent(
                            incExp.avgExpConsist,
                            incExp.avgExp,
                          ),
                          padding: const EdgeInsets.all(0),
                          animation: true,
                          animationDuration: 2500,
                          backgroundColor: Colors.grey[300],
                          progressColor: MyTheme.expenseConsist[0],
                          barRadius: const Radius.circular(20),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 45,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'การออมเเละการลงทุน',
                          style: MyTheme.textTheme.bodyText1,
                        ),
                        Text(
                          '${HelperNumber.format(incExp.avgSavInv)} บ.',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.savingAndInvest[0]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${HelperNumber.format(HelperProgress.getPercent(
                                incExp.avgSavInv,
                                incExp.avgExp,
                              ) * 100)}%',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.savingAndInvest[0]),
                          ),
                        ),
                        LinearPercentIndicator(
                          lineHeight: 16.0,
                          percent: HelperProgress.getPercent(
                            incExp.avgSavInv,
                            incExp.avgExp,
                          ),
                          padding: const EdgeInsets.all(0),
                          animation: true,
                          animationDuration: 2500,
                          backgroundColor: Colors.grey[300],
                          progressColor: MyTheme.savingAndInvest[0],
                          barRadius: const Radius.circular(20),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'รายรับ',
                    style: MyTheme.textTheme.headline4,
                  ),
                  Text(
                    '${HelperNumber.format(incExp.avgInc)} บ.',
                    style: MyTheme.textTheme.headline4!.merge(
                      TextStyle(
                        color: MyTheme.positiveMajor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Flexible(
                    flex: 45,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รายรับจากการทำงาน',
                          style: MyTheme.textTheme.bodyText1,
                        ),
                        Text(
                          '${HelperNumber.format(incExp.avgIncWorking)} บ.',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.incomeWorking[0]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${HelperNumber.format(HelperProgress.getPercent(
                                incExp.avgIncWorking,
                                incExp.avgInc,
                              ) * 100)}%',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.incomeWorking[0]),
                          ),
                        ),
                        LinearPercentIndicator(
                          lineHeight: 16.0,
                          percent: HelperProgress.getPercent(
                            incExp.avgIncWorking,
                            incExp.avgInc,
                          ),
                          padding: const EdgeInsets.all(0),
                          animation: true,
                          animationDuration: 2500,
                          backgroundColor: Colors.grey[300],
                          progressColor: MyTheme.incomeWorking[0],
                          barRadius: const Radius.circular(20),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 45,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รายรับจากสินทรัพย์',
                          style: MyTheme.textTheme.bodyText1,
                        ),
                        Text(
                          '${HelperNumber.format(incExp.avgIncAsset)} บ.',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.incomeAsset[0]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${HelperNumber.format(HelperProgress.getPercent(
                                incExp.avgIncAsset,
                                incExp.avgInc,
                              ) * 100)}%',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.incomeAsset[0]),
                          ),
                        ),
                        LinearPercentIndicator(
                          lineHeight: 16.0,
                          percent: HelperProgress.getPercent(
                            incExp.avgIncAsset,
                            incExp.avgInc,
                          ),
                          padding: const EdgeInsets.all(0),
                          animation: true,
                          animationDuration: 2500,
                          backgroundColor: Colors.grey[300],
                          progressColor: MyTheme.incomeAsset[0],
                          barRadius: const Radius.circular(20),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 45,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รายรับอื่นๆ',
                          style: MyTheme.textTheme.bodyText1,
                        ),
                        Text(
                          '${HelperNumber.format(incExp.avgIncOther)} บ.',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.incomeOther[0]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${HelperNumber.format(HelperProgress.getPercent(
                                incExp.avgIncOther,
                                incExp.avgInc,
                              ) * 100)}%',
                          style: MyTheme.textTheme.bodyText1!.merge(
                            TextStyle(color: MyTheme.incomeOther[0]),
                          ),
                        ),
                        LinearPercentIndicator(
                          lineHeight: 16.0,
                          percent: HelperProgress.getPercent(
                            incExp.avgIncOther,
                            incExp.avgInc,
                          ),
                          padding: const EdgeInsets.all(0),
                          animation: true,
                          animationDuration: 2500,
                          backgroundColor: Colors.grey[300],
                          progressColor: MyTheme.incomeOther[0],
                          barRadius: const Radius.circular(20),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
