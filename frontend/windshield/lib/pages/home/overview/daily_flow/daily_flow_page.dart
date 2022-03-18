import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/main.dart';
import 'package:windshield/providers/daily_flow_provider.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/icon_convertor.dart';

class DailyFlowPage extends ConsumerWidget {
  const DailyFlowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiDFlow);
    return api.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        return Scaffold(
          body: Column(
            children: [
              const DailyList(),
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
        );
      },
    );
  }
}

//ตั้งแต่บนจนก่อนถึงปุ่มย้อนกลับ
class DailyList extends ConsumerWidget {
  const DailyList({Key? key}) : super(key: key);

  get child => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(provDFlow.select((e) => e.pageIdx));
    //final incAssetList = ref.watch(provDFlow.select((e) => e.incAssetList));
    final incTotal = ref.watch(provDFlow.select((e) => e.incTotal));
    final expTotal = ref.watch(provDFlow.select((e) => e.expTotal));
    if (idx == 0) {
      return Expanded(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      height: 170,
                      width: 450,
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
                            children: const [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                                child: Text(
                                  'บัญชีรายรับ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(25.0, 35.0, 0.0, 0.0),
                            child: Text(
                              'รายรับวันนี้',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  decoration: TextDecoration.none
                                  //Theme.of(context).textTheme.bodyText1,
                                  ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    25.0, 5.0, 0.0, 0.0),
                                child: Text(
                                  '$incTotal',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      decoration: TextDecoration.none
                                      //Theme.of(context).textTheme.bodyText1,
                                      ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: const EdgeInsets.only(left: 20),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ), // Background color
                                ),
                                onPressed: () {
                                  ref.read(provDFlow).setPageIdx(1);
                                  // Respond to button press
                                },
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
                                        'รายจ่ายวันนี้\n $expTotal',
                                        style: TextStyle(
                                          fontSize: 12,
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
                Container(color: Colors.white, height: 170),
                const IncWorkingTab(),
                const IncAssetTab(),
                const IncOtherTab(),
              ],
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 170,
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
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                            child: Text(
                              'บัญชีรายจ่าย',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(25.0, 35.0, 0.0, 0.0),
                        child: Text(
                          'รายจ่ายวันนี้',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              decoration: TextDecoration.none
                              //Theme.of(context).textTheme.bodyText1,
                              ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(25.0, 5.0, 0.0, 0.0),
                            child: Text(
                              '$expTotal',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  decoration: TextDecoration.none
                                  //Theme.of(context).textTheme.bodyText1,
                                  ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding: const EdgeInsets.only(left: 20),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ), // Background color
                            ),
                            onPressed: () {
                              ref.read(provDFlow).setPageIdx(0);
                              // Respond to button press
                            },
                            child: Row(
                              children: [
                                Icon(
                                  HelperIcons.getIconData('hand-holding-usd'),
                                  size: 20.0,
                                  color: MyTheme.positiveMajor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'รายรับวันนี้\n $incTotal',
                                    style: TextStyle(
                                      fontSize: 12,
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
                Container(color: Colors.white, height: 170),
                const ExpConTab(),
                const ExpNonConTab(),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class IncWorkingTab extends ConsumerWidget {
  const IncWorkingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorkingList = ref.watch(provDFlow.select((e) => e.incWorkingList));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('รายรับจากการทำงาน', style: MyTheme.textTheme.headline3),
        GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: incWorkingList.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (_, index) {
            return Column(
              children: [
                if (incWorkingList[index].flows.length > 0) ...[
                  Container(
                    child: Icon(
                      HelperIcons.getIconData(incWorkingList[index].icon),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: MyTheme.positiveMajor, shape: BoxShape.circle),
                  ),
                  Text(incWorkingList[index].name)
                ] else ...[
                  Container(
                    child: Icon(
                      HelperIcons.getIconData(incWorkingList[index].icon),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: MyTheme.positiveMinor, shape: BoxShape.circle),
                  ),
                  Text(incWorkingList[index].name)
                ]
              ],
            );
          },
        ),
      ],
    );
  }
}

class IncAssetTab extends ConsumerWidget {
  const IncAssetTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incAssetList = ref.watch(provDFlow.select((e) => e.incAssetList));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('รายรับจากสินทรัพย์', style: MyTheme.textTheme.headline3),
        GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: incAssetList.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (_, index) {
            return Column(
              children: [
                Container(
                  child: Icon(HelperIcons.getIconData(incAssetList[index].icon),
                      color: Colors.white),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: MyTheme.positiveMajor, shape: BoxShape.circle),
                ),
                Text(incAssetList[index].name)
              ],
            );
          },
        ),
      ],
    );
  }
}

class IncOtherTab extends ConsumerWidget {
  const IncOtherTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incOtherList = ref.watch(provDFlow.select((e) => e.incOtherList));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('รายรับอื่นๆ', style: MyTheme.textTheme.headline3),
        GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: incOtherList.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (_, index) {
            return Column(
              children: [
                Container(
                  child: Icon(HelperIcons.getIconData(incOtherList[index].icon),
                      color: Colors.white),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: MyTheme.positiveMajor, shape: BoxShape.circle),
                ),
                Text(incOtherList[index].name)
              ],
            );
          },
        ),
      ],
    );
  }
}

class ExpConTab extends ConsumerWidget {
  const ExpConTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expConList = ref.watch(provDFlow.select((e) => e.incOtherList));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('รายจ่ายคงที่', style: MyTheme.textTheme.headline3),
        GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: expConList.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (_, index) {
            return Column(
              children: [
                Container(
                  child: Icon(HelperIcons.getIconData(expConList[index].icon),
                      color: Colors.white),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: MyTheme.negativeMajor, shape: BoxShape.circle),
                ),
                Text(expConList[index].name)
              ],
            );
          },
        ),
      ],
    );
  }
}

class ExpNonConTab extends ConsumerWidget {
  const ExpNonConTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expNonConList = ref.watch(provDFlow.select((e) => e.incOtherList));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('รายจ่ายไม่คงที่', style: MyTheme.textTheme.headline3),
        GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: expNonConList.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (_, index) {
            return Column(
              children: [
                Container(
                  child: Icon(
                      HelperIcons.getIconData(expNonConList[index].icon),
                      color: Colors.white),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: MyTheme.negativeMajor, shape: BoxShape.circle),
                ),
                Text(expNonConList[index].name)
              ],
            );
          },
        ),
      ],
    );
  }
}
