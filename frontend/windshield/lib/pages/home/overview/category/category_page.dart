import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windshield/main.dart';
import 'package:windshield/pages/home/overview/balance_sheet/create_balance.dart';
import 'package:windshield/pages/home/overview/category/deleteCat.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/ftype_coler.dart';
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
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text('จัดการหมวดหมู่',
                        style: MyTheme.whiteTextTheme.headline1),
                  ),
                  height: 90,
                  width: 500,
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
      //GoalList(),
    ]));
  }
}

class IncWorking extends ConsumerWidget {
  const IncWorking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorking = ref.watch(provCat.select((e) => e.incWorkingList));

    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('รายได้จากการทำงาน', style: MyTheme.textTheme.headline3),
        ),
      ),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: incWorking.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          //ปุ่มเพิ่ม
          itemBuilder: (_, i) {
            if (i == incWorking.length) {
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
                            onPressed: () {
                              ref.read(provCat).setCurftype('1');
                              ref.read(provCat).setFtype('1');
                              ref.read(provCat).setIsAdd(true);

                              showModalBottomSheet(
                                  //useRootNavigator: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) {
                                    return DeleteCat();
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              //elevation: 0.0,
                              //shadowColor: Colors
                              //    .transparent, //remove shadow on button
                              primary: HelperColor.getFtColor('1', 0),
                              textStyle: MyTheme.textTheme.headline4,
                              padding: const EdgeInsets.all(10),

                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('เพิ่ม'),
                  ],
                ),
              );
            }
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
                          onPressed: () {
                            //มาต่อตรงนี้
                            //ref.watch(provCat).seticonList(incWorking);
                            ref.read(provCat).setCurrCat(incWorking[i]);
                            ref.read(provCat).setFtype(incWorking[i].ftype);
                            ref.read(provCat).setId(incWorking[i].id);
                            print("id = ");
                            print(incWorking[i].id);
                            ref.read(provCat).setIsAdd(false);

                            showModalBottomSheet(
                                //useRootNavigator: true,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (_) {
                                  return DeleteCat();
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary:
                                HelperColor.getFtColor(incWorking[i].ftype, 0),
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
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('รายได้จากทรัพย์สิน', style: MyTheme.textTheme.headline3),
        ),
      ),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: incAsset.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          //ปุ่มเพิ่ม
          itemBuilder: (_, i) {
            if (i == incAsset.length) {
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
                            onPressed: () {
                              ref.read(provCat).setCurftype('2');
                              ref.read(provCat).setFtype('2');
                              ref.read(provCat).setIsAdd(true);

                              showModalBottomSheet(
                                  //useRootNavigator: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) {
                                    return DeleteCat();
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              //elevation: 0.0,
                              //shadowColor: Colors
                              //    .transparent, //remove shadow on button
                              primary: HelperColor.getFtColor('2', 0),
                              textStyle: MyTheme.textTheme.headline4,
                              padding: const EdgeInsets.all(10),

                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('เพิ่ม'),
                  ],
                ),
              );
            }
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
                          onPressed: () {
                            //มาต่อตรงนี้
                            //ref.watch(provCat).seticonList(incWorking);
                            ref.read(provCat).setCurrCat(incAsset[i]);
                            ref.read(provCat).setFtype(incAsset[i].ftype);
                            ref.read(provCat).setId(incAsset[i].id);
                            print("id = ");
                            print(incAsset[i].id);
                            ref.read(provCat).setIsAdd(false);

                            showModalBottomSheet(
                                //useRootNavigator: true,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (_) {
                                  return DeleteCat();
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary:
                                HelperColor.getFtColor(incAsset[i].ftype, 0),
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
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('รายได้อื่นๆ', style: MyTheme.textTheme.headline3),
        ),
      ),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: incOther.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          //ปุ่มเพิ่ม
          itemBuilder: (_, i) {
            if (i == incOther.length) {
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
                            onPressed: () {
                              ref.read(provCat).setCurftype('3');
                              ref.read(provCat).setFtype('3');
                              ref.read(provCat).setIsAdd(true);

                              showModalBottomSheet(
                                  //useRootNavigator: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) {
                                    return DeleteCat();
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              //elevation: 0.0,
                              //shadowColor: Colors
                              //    .transparent, //remove shadow on button
                              primary: HelperColor.getFtColor('3', 0),
                              textStyle: MyTheme.textTheme.headline4,
                              padding: const EdgeInsets.all(10),

                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('เพิ่ม'),
                  ],
                ),
              );
            }
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
                          onPressed: () {
                            //มาต่อตรงนี้
                            //ref.watch(provCat).seticonList(incWorking);
                            ref.read(provCat).setCurrCat(incOther[i]);
                            ref.read(provCat).setFtype(incOther[i].ftype);
                            ref.read(provCat).setId(incOther[i].id);
                            print("id = ");
                            print(incOther[i].id);
                            ref.read(provCat).setIsAdd(false);

                            showModalBottomSheet(
                                //useRootNavigator: true,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (_) {
                                  return DeleteCat();
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary:
                                HelperColor.getFtColor(incOther[i].ftype, 0),
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
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('รายจ่ายไม่คงที่', style: MyTheme.textTheme.headline3),
        ),
      ),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: expInconsist.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          //ปุ่มเพิ่ม
          itemBuilder: (_, i) {
            if (i == expInconsist.length) {
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
                            onPressed: () {
                              ref.read(provCat).setCurftype('4');
                              ref.read(provCat).setFtype('4');
                              ref.read(provCat).setIsAdd(true);

                              showModalBottomSheet(
                                  //useRootNavigator: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) {
                                    return DeleteCat();
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              //elevation: 0.0,
                              //shadowColor: Colors
                              //    .transparent, //remove shadow on button
                              primary: HelperColor.getFtColor('4', 0),
                              textStyle: MyTheme.textTheme.headline4,
                              padding: const EdgeInsets.all(10),

                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('เพิ่ม'),
                  ],
                ),
              );
            }
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
                          onPressed: () {
                            //มาต่อตรงนี้
                            //ref.watch(provCat).seticonList(incWorking);
                            ref.read(provCat).setCurrCat(expInconsist[i]);
                            ref.read(provCat).setFtype(expInconsist[i].ftype);
                            ref.read(provCat).setId(expInconsist[i].id);
                            print("id = ");
                            print(expInconsist[i].id);
                            ref.read(provCat).setIsAdd(false);

                            showModalBottomSheet(
                                //useRootNavigator: true,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (_) {
                                  return DeleteCat();
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary: HelperColor.getFtColor(
                                expInconsist[i].ftype, 0),
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
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('รายจ่ายคงที่', style: MyTheme.textTheme.headline3),
        ),
      ),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: expConsist.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          //ปุ่มเพิ่ม
          itemBuilder: (_, i) {
            if (i == expConsist.length) {
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
                            onPressed: () {
                              ref.read(provCat).setCurftype('5');
                              ref.read(provCat).setFtype('5');
                              ref.read(provCat).setIsAdd(true);

                              showModalBottomSheet(
                                  //useRootNavigator: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) {
                                    return DeleteCat();
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              //elevation: 0.0,
                              //shadowColor: Colors
                              //    .transparent, //remove shadow on button
                              primary: HelperColor.getFtColor('5', 0),
                              textStyle: MyTheme.textTheme.headline4,
                              padding: const EdgeInsets.all(10),

                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('เพิ่ม'),
                  ],
                ),
              );
            }
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
                          onPressed: () {
                            //มาต่อตรงนี้
                            //ref.watch(provCat).seticonList(incWorking);
                            ref.read(provCat).setCurrCat(expConsist[i]);
                            ref.read(provCat).setFtype(expConsist[i].ftype);
                            ref.read(provCat).setId(expConsist[i].id);
                            print("id = ");
                            print(expConsist[i].id);
                            ref.read(provCat).setIsAdd(false);

                            showModalBottomSheet(
                                //useRootNavigator: true,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (_) {
                                  return DeleteCat();
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary:
                                HelperColor.getFtColor(expConsist[i].ftype, 0),
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
                  Text(expConsist[i].name),
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
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('การออมและการลงทุน', style: MyTheme.textTheme.headline3),
        ),
      ),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: savInv.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          //ปุ่มเพิ่ม
          itemBuilder: (_, i) {
            if (i == savInv.length) {
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
                            onPressed: () {
                              ref.read(provCat).setCurftype('6');
                              ref.read(provCat).setFtype('6');
                              ref.read(provCat).setIsAdd(true);

                              showModalBottomSheet(
                                  //useRootNavigator: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) {
                                    return DeleteCat();
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              //elevation: 0.0,
                              //shadowColor: Colors
                              //    .transparent, //remove shadow on button
                              primary: HelperColor.getFtColor('6', 0),
                              textStyle: MyTheme.textTheme.headline4,
                              padding: const EdgeInsets.all(10),

                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('เพิ่ม'),
                  ],
                ),
              );
            }
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
                          onPressed: () {
                            //มาต่อตรงนี้
                            //ref.watch(provCat).seticonList(incWorking);
                            ref.read(provCat).setCurrCat(savInv[i]);
                            ref.read(provCat).setFtype(savInv[i].ftype);
                            ref.read(provCat).setId(savInv[i].id);
                            print("id = ");
                            print(savInv[i].id);
                            ref.read(provCat).setIsAdd(false);

                            showModalBottomSheet(
                                //useRootNavigator: true,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (_) {
                                  return DeleteCat();
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary: HelperColor.getFtColor(savInv[i].ftype, 0),
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
                  Text(savInv[i].name),
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
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('เป้าหมายทางการเงิน', style: MyTheme.textTheme.headline3),
        ),
      ),
      GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: goalList.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          //ปุ่มเพิ่ม
          itemBuilder: (_, i) {
            if (i == goalList.length) {
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
                            onPressed: () {
                              ref.read(provCat).setCurftype('7');
                              ref.read(provCat).setFtype('7');
                              ref.read(provCat).setIsAdd(true);

                              showModalBottomSheet(
                                  //useRootNavigator: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) {
                                    return DeleteCat();
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              //elevation: 0.0,
                              //shadowColor: Colors
                              //    .transparent, //remove shadow on button
                              primary: HelperColor.getFtColor('7', 0),
                              textStyle: MyTheme.textTheme.headline4,
                              padding: const EdgeInsets.all(10),

                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('เพิ่ม'),
                  ],
                ),
              );
            }
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
                          onPressed: () {
                            //มาต่อตรงนี้
                            //ref.watch(provCat).seticonList(incWorking);
                            ref.read(provCat).setCurrCat(goalList[i]);
                            ref.read(provCat).setFtype(goalList[i].ftype);
                            ref.read(provCat).setId(goalList[i].id);
                            print("id = ");
                            print(goalList[i].id);
                            ref.read(provCat).setIsAdd(false);

                            showModalBottomSheet(
                                //useRootNavigator: true,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (_) {
                                  return DeleteCat();
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            //elevation: 0.0,
                            //shadowColor: Colors
                            //    .transparent, //remove shadow on button
                            primary:
                                HelperColor.getFtColor(goalList[i].ftype, 0),
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
                  Text(goalList[i].name),
                ],
              ),
            );
          }),
    ]);
  }
}
