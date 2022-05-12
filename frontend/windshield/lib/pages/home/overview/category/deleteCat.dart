import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windshield/components/loading.dart';
import 'package:windshield/main.dart';
import 'package:windshield/pages/home/overview/category/category_page.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/ftype_coler.dart';
import 'package:windshield/utility/icon_convertor.dart';

class DeleteCat extends ConsumerStatefulWidget {
  const DeleteCat({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeleteCatState();
}

class _DeleteCatState extends ConsumerState<DeleteCat> {
  @override
  Widget build(BuildContext context) {
    final curCat = ref.watch(provCat.select((e) => e.currCat));
    // final curFtype = ref.watch(provCat.select((e) => e.curFtype));
    final ftype = ref.watch(provCat.select((e) => e.ftype));
    final name = ref.watch(provCat.select((e) => e.name));
    final isAdd = ref.watch(provCat.select((e) => e.isAdd));
    //final icon = ref.watch(provCat.select((e) => e.icon));
    //final curiCon = ref.watch(provCat.select((e) => e.icon));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: HelperColor.getFtColor(ftype, 0),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              isAdd ? '' : curCat.name,
              style: MyTheme.whiteTextTheme.headline3,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 75,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            //ช่องกรอกชื่อสีเทา
                            children: [
                              TextFormField(
                                initialValue: name,
                                textAlign: TextAlign.center,
                                style: MyTheme.textTheme.headline4,
                                decoration: InputDecoration(
                                  hintText: 'โปรดระบุชื่อหมวดหมู่',
                                  hintStyle: MyTheme.textTheme.bodyText1!.merge(
                                    TextStyle(
                                      color: Colors.grey.withOpacity(.7),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.2),
                                      width: 1.5,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(.2),
                                      width: 1.5,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                onChanged: (e) {
                                  ref.read(provCat).setName(e);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      //เลือก icons
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HelperColor.getFtColor(ftype, 0),
                            ),
                            child: Icon(
                              HelperIcons.getIconData(ref.watch(provCat).icon),
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => const ChooseIcons(),
                            );
                          },
                        ),
                      ), //Containerxt
                    ],
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Expanded(child: Container()),
                      //บันทึกลงฟอร์ม
                      SizedBox(
                        height: 50,
                        width: 360,
                        //width: MediaQuery.of(context).size.width - 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            //ref.read(provCat).setIcon();
                            showLoading(context);
                            ref.read(provCat).setFtype(ftype);
                            if (ref.watch(provCat.select((e) => e.isAdd))) {
                              final asset =
                                  await ref.read(apiProvider).addCategory(
                                        ref.read(provCat).name,
                                        ref.read(provCat).icon,
                                        ref.read(provCat).ftype,
                                      );
                              if (asset) {
                                AutoRouter.of(context)
                                    .popUntilRouteWithName('CategoryRoute');
                                ref.read(provCat).setNeedFetchAPI();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('เกิดข้อผิดพลาด'),
                                  ),
                                );
                              }
                            } else {
                              final asset =
                                  await ref.read(apiProvider).editCategory(
                                        ref.read(provCat).id,
                                        ref.read(provCat).name,
                                        ref.read(provCat).icon,
                                      );
                              if (asset) {
                                AutoRouter.of(context)
                                    .popUntilRouteWithName('CategoryRoute');
                                ref.read(provCat).setNeedFetchAPI();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('เกิดข้อผิดพลาด'),
                                  ),
                                );
                              }
                            }
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),
                          child: Text(
                            'บันทึก',
                            style: MyTheme.whiteTextTheme.headline3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      //ลบออก
                      if (ref.watch(provCat.select((e) => !e.isAdd)))
                        SizedBox(
                          height: 50,
                          width: 360,
                          //width: MediaQuery.of(context).size.width - 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              showLoading(context);
                              final asset =
                                  await ref.read(apiProvider).deleteCategory(
                                        ref.read(provCat).id,
                                        //ref.read(provCat).icon,
                                      );
                              if (asset) {
                                AutoRouter.of(context)
                                    .popUntilRouteWithName('CategoryRoute');
                                ref.read(provCat).setNeedFetchAPI();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('เกิดข้อผิดพลาด'),
                                  ),
                                );
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                            child: Text(
                              'ลบ',
                              style: MyTheme.whiteTextTheme.headline3,
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
      ],
    );
  }
}

class ChooseIcons extends ConsumerWidget {
  const ChooseIcons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ftype = ref.watch(provCat.select((e) => e.ftype));
    return Container(
      height: MediaQuery.of(context).size.height -
          (MediaQuery.of(context).size.height / 4),
      color: Colors.white,
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(helpericons.length, (i) {
          return Center(
            child: GestureDetector(
              onTap: () {
                //ref.watch(provCat).setIcon(icons[i].toString());
                ref.watch(provCat).setIcon(helpericons[i].toString());
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor:
                    helpericons[i].toString() == ref.watch(provCat).icon
                        ? HelperColor.getFtColor(ftype, 0)
                        : HelperColor.getFtColor(ftype, 1),
                radius: 40,
                child: FittedBox(
                  child: Icon(
                    HelperIcons.getIconData(helpericons[i].toString()),
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
            // Icon(icons[i]),
          );
        }),
      ),
    );
  }
}
