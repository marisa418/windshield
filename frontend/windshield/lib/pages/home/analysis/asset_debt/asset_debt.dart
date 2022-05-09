import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:windshield/main.dart';
import 'package:windshield/pages/home/analysis/asset_debt/asset_debt_model.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'asset_debt_provider.dart';

final provAssDebt = ChangeNotifierProvider.autoDispose<AssetDebtProvider>(
    (ref) => AssetDebtProvider());

final apiAssDebt = FutureProvider.autoDispose<void>((ref) async {
  final data = await ref.read(apiProvider).analBsheet();
  final graph = await ref.read(apiProvider).analBsheetGraph();
  ref.read(provAssDebt).setAssetDebt(data);
  ref.read(provAssDebt).setGraph(graph);
});

class AssetDebtTab extends ConsumerWidget {
  const AssetDebtTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(provAssDebt).assetDebt;
    final api = ref.watch(apiAssDebt);
    return api.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (_) => Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            Text(
              'ความมั่งคั่งสุทธิ',
              style: MyTheme.textTheme.headline4!.merge(
                const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Graph(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'อัตราการเปลี่ยนเเปลงเฉลี่ย',
                style: MyTheme.textTheme.headline4!.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('หนี้สิน',
                    // style: MyTheme.textTheme.headline4!.merge(
                    //   const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    style: MyTheme.textTheme.headline4),
                Text(
                  '${HelperNumber.format(balance.avgDebt)} บ.',
                  style: MyTheme.textTheme.headline4!.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme.negativeMajor,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('สินทรัพย์',
                    // style: MyTheme.textTheme.headline4!.merge(
                    //   const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    style: MyTheme.textTheme.headline4),
                Text(
                  '${HelperNumber.format(balance.avgAsset)} บ.',
                  style: MyTheme.textTheme.headline4!.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme.assetInvest[0],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ความมั่งคั่งสุทธิ',
                    // style: MyTheme.textTheme.headline4!.merge(
                    //   const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    style: MyTheme.textTheme.headline4),
                Text(
                  '${HelperNumber.format(balance.avgBalance)} บ.',
                  style: MyTheme.textTheme.headline4!.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme.primaryMajor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'มูลค่าสูงสุด',
                style: MyTheme.textTheme.headline4!.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('หนี้สิน',
                    // style: MyTheme.textTheme.headline4!.merge(
                    //   const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    style: MyTheme.textTheme.headline4),
                Text(
                  '${HelperNumber.format(balance.maxDebt)} บ.',
                  style: MyTheme.textTheme.headline4!.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme.negativeMajor,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('สินทรัพย์',
                    // style: MyTheme.textTheme.headline4!.merge(
                    //   const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    style: MyTheme.textTheme.headline4),
                Text(
                  '${HelperNumber.format(balance.maxAsset)} บ.',
                  style: MyTheme.textTheme.headline4!.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme.assetInvest[0],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ความมั่งคั่งสุทธิ',
                    // style: MyTheme.textTheme.headline4!.merge(
                    //   const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    style: MyTheme.textTheme.headline4),
                Text(
                  '${HelperNumber.format(balance.maxBalance)} บ.',
                  style: MyTheme.textTheme.headline4!.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme.primaryMajor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'มูลค่าต่ำสุด',
                style: MyTheme.textTheme.headline4!.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('หนี้สิน',
                    // style: MyTheme.textTheme.headline4!.merge(
                    //   const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    style: MyTheme.textTheme.headline4),
                Text(
                  '${HelperNumber.format(balance.minDebt)} บ.',
                  style: MyTheme.textTheme.headline4!.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme.negativeMajor,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('สินทรัพย์',
                    // style: MyTheme.textTheme.headline4!.merge(
                    //   const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    style: MyTheme.textTheme.headline4),
                Text(
                  '${HelperNumber.format(balance.minAsset)} บ.',
                  style: MyTheme.textTheme.headline4!.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme.assetInvest[0],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ความมั่งคั่งสุทธิ',
                    // style: MyTheme.textTheme.headline4!.merge(
                    //   const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    style: MyTheme.textTheme.headline4),
                Text(
                  '${HelperNumber.format(balance.minBalance)} บ.',
                  style: MyTheme.textTheme.headline4!.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme.primaryMajor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class Graph extends ConsumerWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graph = ref.watch(provAssDebt.select((e) => e.graph))
      ..sort((a, b) => a.id.compareTo(b.id));
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.top,
        ),
        series: <ChartSeries>[
          LineSeries<AssetDebtGraph, String>(
            dataSource: graph,
            xValueMapper: (AssetDebtGraph data, _) =>
                DateFormat('d MMM y\nHH:mm:ss').format(data.timestamp),
            yValueMapper: (AssetDebtGraph data, _) => data.asset,
            markerSettings: const MarkerSettings(isVisible: true),
            name: 'สินทรัพย์',
            color: MyTheme.assetLiquid[0],
          ),
          LineSeries<AssetDebtGraph, String>(
            dataSource: graph,
            xValueMapper: (AssetDebtGraph data, _) =>
                DateFormat('d MMM y\nHH:mm:ss').format(data.timestamp),
            yValueMapper: (AssetDebtGraph data, _) => data.debt,
            markerSettings: const MarkerSettings(isVisible: true),
            name: 'หนี้สิน',
            color: MyTheme.debtShort[0],
          ),
        ],
      ),
    );
  }
}
