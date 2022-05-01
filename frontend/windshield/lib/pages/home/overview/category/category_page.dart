import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windshield/main.dart';
import 'package:windshield/pages/home/overview/balance_sheet/create_balance.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';
import '../../../../providers/category_provider.dart';

final provCat = ChangeNotifierProvider.autoDispose<CategoryProvider>(
    (ref) => CategoryProvider());
final apiCat = FutureProvider.autoDispose<void>((ref) async {
  ref.watch(provCat.select((value) => value.needFetchAPI));

  final data = await ref.read(apiProvider).getAllCategories(false);
  ref.read(provCat).setCat(data);

  ref.read(provCat).setCatType();
});

class CategoryPage extends ConsumerWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref.watch(provBSheet.select((value) => value.needFetchAPI));
    final api = ref.watch(apiCat);
    return api.when(
      error: (error, stackTrace) => Text(stackTrace.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (_) {
        return Scaffold(
          body: Column(
            children: [
              
              Container(
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('test',style: MyTheme.whiteTextTheme.headline2),
                ),
                height: 190,
                width:500,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromARGB(255, 82, 54, 255),
                        Color.fromARGB(255, 117, 161, 227),
                      ]),
                  //borderRadius: BorderRadius.circular(10),
                ),
              ),
              Body(),

              //ปุ่มย้อนกลับ
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

class Body extends ConsumerWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        child: ListView(children: [
      IncWorking(),
      IncAsset(),
      IncOther(),
      ExpInconsist(),
      ExpConsist(),
      SavInv(),
      GoalList(),
    ]));
  }
}

class IncWorking extends ConsumerWidget {
  const IncWorking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorking = ref.watch(provCat.select((e) => e.incWorkingList));

    return Column(children: [
      Text('IncWorking', style: MyTheme.textTheme.headline2),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: incWorking.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          itemBuilder: (_, i) {
            return SizedBox(
              height: 100,
              width: 110,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            60, //height of button แก้ตอนเลือกประเภท overflow
                        width: 75, //width of button
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary: getcolor(incWorking[i].ftype),
                            textStyle: MyTheme.textTheme.headline4,
                            padding: const EdgeInsets.all(10),

                            shape: const CircleBorder(),
                          ),
                          child: Icon(
                            HelperIcons.getIconData(incWorking[i].icon),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(incWorking[i].name)
                ],
              ),
            );
          }),
    ]);
  }
}

class IncAsset extends ConsumerWidget {
  const IncAsset({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incAsset = ref.watch(provCat.select((e) => e.incAssetList));

    return Column(children: [
      Text('IncAsset', style: MyTheme.textTheme.headline2),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: incAsset.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          itemBuilder: (_, i) {
            return SizedBox(
              height: 100,
              width: 110,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            60, //height of button แก้ตอนเลือกประเภท overflow
                        width: 75, //width of button
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary: getcolor(incAsset[i].ftype),
                            textStyle: MyTheme.textTheme.headline4,
                            padding: const EdgeInsets.all(10),

                            shape: const CircleBorder(),
                          ),
                          child: Icon(
                            HelperIcons.getIconData(incAsset[i].icon),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(incAsset[i].name)
                ],
              ),
            );
          }),
    ]);
  }
}

class IncOther extends ConsumerWidget {
  const IncOther({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incOther = ref.watch(provCat.select((e) => e.incOtherList));

    return Column(children: [
      Text('incOther', style: MyTheme.textTheme.headline2),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: incOther.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          itemBuilder: (_, i) {
            return SizedBox(
              height: 100,
              width: 110,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            60, //height of button แก้ตอนเลือกประเภท overflow
                        width: 75, //width of button
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary: getcolor(incOther[i].ftype),
                            textStyle: MyTheme.textTheme.headline4,
                            padding: const EdgeInsets.all(10),

                            shape: const CircleBorder(),
                          ),
                          child: Icon(
                            HelperIcons.getIconData(incOther[i].icon),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(incOther[i].name)
                ],
              ),
            );
          }),
    ]);
  }
}

class ExpInconsist extends ConsumerWidget {
  const ExpInconsist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expInconsist = ref.watch(provCat.select((e) => e.expInconsistList));

    return Column(children: [
      Text('expInconsist', style: MyTheme.textTheme.headline2),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: expInconsist.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          itemBuilder: (_, i) {
            return SizedBox(
              height: 100,
              width: 110,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            60, //height of button แก้ตอนเลือกประเภท overflow
                        width: 75, //width of button
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary: getcolor(expInconsist[i].ftype),
                            textStyle: MyTheme.textTheme.headline4,
                            padding: const EdgeInsets.all(10),

                            shape: const CircleBorder(),
                          ),
                          child: Icon(
                            HelperIcons.getIconData(expInconsist[i].icon),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(expInconsist[i].name)
                ],
              ),
            );
          }),
    ]);
  }
}

class ExpConsist extends ConsumerWidget {
  const ExpConsist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expConsist = ref.watch(provCat.select((e) => e.expConsistList));

    return Column(children: [
      Text('expConsist', style: MyTheme.textTheme.headline2),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: expConsist.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          itemBuilder: (_, i) {
            return SizedBox(
              height: 100,
              width: 110,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            60, //height of button แก้ตอนเลือกประเภท overflow
                        width: 75, //width of button
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary: getcolor(expConsist[i].ftype),
                            textStyle: MyTheme.textTheme.headline4,
                            padding: const EdgeInsets.all(10),

                            shape: const CircleBorder(),
                          ),
                          child: Icon(
                            HelperIcons.getIconData(expConsist[i].icon),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(expConsist[i].name)
                ],
              ),
            );
          }),
    ]);
  }
}

class SavInv extends ConsumerWidget {
  const SavInv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savInv = ref.watch(provCat.select((e) => e.savInvList));

    return Column(children: [
      Text('savInv', style: MyTheme.textTheme.headline2),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: savInv.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          itemBuilder: (_, i) {
            return SizedBox(
              height: 100,
              width: 110,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            60, //height of button แก้ตอนเลือกประเภท overflow
                        width: 75, //width of button
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary: getcolor(savInv[i].ftype),
                            textStyle: MyTheme.textTheme.headline4,
                            padding: const EdgeInsets.all(10),

                            shape: const CircleBorder(),
                          ),
                          child: Icon(
                            HelperIcons.getIconData(savInv[i].icon),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(savInv[i].name)
                ],
              ),
            );
          }),
    ]);
  }
}

class GoalList extends ConsumerWidget {
  const GoalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalList = ref.watch(provCat.select((e) => e.goalList));

    return Column(children: [
      Text('goalList', style: MyTheme.textTheme.headline2),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: goalList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          itemBuilder: (_, i) {
            return SizedBox(
              height: 100,
              width: 110,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            60, //height of button แก้ตอนเลือกประเภท overflow
                        width: 75, //width of button
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary: getcolor(goalList[i].ftype),
                            textStyle: MyTheme.textTheme.headline4,
                            padding: const EdgeInsets.all(10),

                            shape: const CircleBorder(),
                          ),
                          child: Icon(
                            HelperIcons.getIconData(goalList[i].icon),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(goalList[i].name)
                ],
              ),
            );
          }),
    ]);
  }
}
