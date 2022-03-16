import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/main.dart';
import 'package:windshield/providers/daily_flow_provider.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/routes/app_router.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(provDFlow.select((e) => e.pageIdx));
    if (idx == 0) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 170,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    colors: MyTheme.majorBackground,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Container(color: Colors.blue, height: 170),
              const IncWorkingTab(),
              const IncAssetTab(),
              const IncOtherTab(),
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(color: Colors.pink, height: 170),
              Container(color: Colors.red, height: 170),
              // ตรงนี้ให้หลิวใส่ tab ของพวก _exp
            ],
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
            return Container(
              height: 50,
              width: 50,
              color: Colors.purple,
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
            return Container(
              height: 50,
              width: 50,
              color: Colors.purple,
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
        const Text('รายรับอื่นๆ'),
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
            return Container(
              height: 50,
              width: 50,
              color: Colors.purple,
            );
          },
        ),
      ],
    );
  }
}
