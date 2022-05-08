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
                height: 190,
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
  const Body({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ListView(
        children: [
          IncWorking(),

        ]
      )
    );
  }
}

class IncWorking extends ConsumerWidget {
  const IncWorking({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorking = ref.watch(provCat.select((e)=> e.incWorkingList));

    return Column(
      children: [
        Text('test'),
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
                                  onPressed: () {
                                    
                                  },
                                  style: ElevatedButton.styleFrom(
                                    //elevation: 0.0,
                                    //shadowColor: Colors
                                    //    .transparent, //remove shadow on button
                                    primary: getcolor(incWorking[i].ftype),
                                    textStyle: MyTheme.whiteTextTheme.headline4,
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
      ]
    );
  }
}

