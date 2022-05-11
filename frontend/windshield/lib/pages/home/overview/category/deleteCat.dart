import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:windshield/main.dart';
import 'package:windshield/models/balance_sheet/balance_sheet.dart';
import 'package:windshield/models/daily_flow/flow.dart';
import 'package:windshield/pages/home/overview/category/category_page.dart';
import 'package:windshield/styles/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:badges/badges.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/ftype_coler.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:flutter/cupertino.dart';

class DeleteCat extends ConsumerWidget {
  const DeleteCat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    

    return Expanded(
      child: Test2Form(),
      );
  }
}


class Test2Form extends ConsumerStatefulWidget {
  const Test2Form({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestFormState();
}

class _TestFormState extends ConsumerState<Test2Form> {

  @override
  Widget build(BuildContext context) {
    final curCat = ref.watch(provCat.select((e) => e.currCat)); 
    final curFtype = ref.watch(provCat.select((e) => e.curFtype));
    final ftype = ref.watch(provCat.select((e) => e.ftype));
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
              child: Text(curCat.name, style: MyTheme.whiteTextTheme.headline3),
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

                          child: Container(
                            height: 55,
                            width: MediaQuery.of(context).size.width - 70,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 7),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.2),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                //ช่องกรอกชื่อสีเทา
                                children: [
                                  TextFormField(
                                initialValue: curCat.name,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'โปรดระบุชื่อหมวดหมู่',
                                  hintStyle: MyTheme.textTheme.bodyText1,
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
                        ),
                        //เลือก icons
                        Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: InkWell(
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HelperColor.getFtColor(ftype, 0),
                              ),
                              child: Icon(
                                HelperIcons.getIconData(
                                    ref.watch(provCat).icon),
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            onTap: () {
                              // showDialogref.read(provCat).seticonList(curCat);
                              //ref.read(provCat).helpericons;
                              print('provCat.icon = ');
                              print(ref.read(provCat).icon);
                              
                              //print(ref.watch(provFGoal).goal);
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                isScrollControlled: true,
                                // builder: (_) {
                                //   return page2();
                                // }
                                builder: (context) {
                                  return SizedBox(
                                      height: 530, child: ChooseIcons());
                                },
                              );
                            },
                          ),
                        ),
                      ), //Containerxt
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: 
                         Column(
                            children: [
                              const SizedBox(height: 30),
                              
                              const SizedBox(height: 30),
                              
                              const SizedBox(height: 30),
                              
                              Expanded(child: Container()),
                              //บันทึกลงฟอร์ม
                              SizedBox(
                                height: 50,
                                width: 360,
                                //width: MediaQuery.of(context).size.width - 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //ref.read(provCat).setIcon();
                                    ref.read(provCat).setFtype(ftype);
                                    print("Curcat.ftype");
                                    print(ftype);
                                    if (ref.watch(
                                        provCat.select((e) => e.isAdd))) {
                                      final asset =
                                          await ref.read(apiProvider).addCategory(
                                                ref.read(provCat).name,
                                                ref.read(provCat).icon,
                                                ref.read(provCat).ftype,
                                                
                                              );
                                      print('provCat.name = ');
                                      print(ref.read(provCat).name);
                                      print('provCat.icon = ');
                                      print(ref.read(provCat).icon);
                                      print('provCat.ftype = ');
                                      print(ref.read(provCat).ftype);
                                      if (asset) {
                                        
                                        ref.read(provCat).setNeedFetchAPI();
                                        AutoRouter.of(context).pop();
                                      }
                                    } else {
                                      var a = ref.read(provCat).id;
                                      print("id = ");
                                      print(a);
                                      final asset =
                                          await ref.read(apiProvider).editCategory(
                                                ref.read(provCat).id,
                                                ref.read(provCat).name,
                                                ref.read(provCat).icon,
                                                
                                              );
                                      if (asset) {
                                        print("id = ");
                                        print(curCat.id);
                                        ref.read(provCat).setNeedFetchAPI();
                                        AutoRouter.of(context).pop();
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    ),
                                  ),
                                  child: Text('บันทึก',
                                      style: MyTheme.whiteTextTheme.headline3),
                                ),
                              ),
                              SizedBox(
                                height: 18.0,
                              ),
                              //ลบออก
                              if (ref.watch(provCat.select((e) => !e.isAdd)))
                                SizedBox(
                                  height: 50,
                                  width: 360,
                                  //width: MediaQuery.of(context).size.width - 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final asset = await ref
                                          .read(apiProvider)
                                          .deleteCategory(
                                            ref.read(provCat).id,
                                            //ref.read(provCat).icon,
                                            
                                          );
                                      if (asset) {
                                        ref.read(provCat).setNeedFetchAPI();
                                        AutoRouter.of(context).pop();
                                      }
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                        ),
                                      ),
                                    ),
                                    child: Text('ลบ',
                                        style:
                                            MyTheme.whiteTextTheme.headline3),
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

    final Icons = ref.watch(provCat.select((e) => e.icon));
    
    final ftype = ref.watch(provCat.select((e) => e.ftype));
    return Container(
      color: Colors.white,
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(helpericons.length, (i) {
          return Center(
            child: InkWell(
              child: CircleAvatar(
                  backgroundColor:
                      helpericons[i].toString() == ref.watch(provCat).icon
                          ?HelperColor.getFtColor(ftype, 0)
                          :HelperColor.getFtColor(ftype, 1),
                          //: Color(0xFF5236FF).withOpacity(0.4),
                  radius: 40,
                  child: FittedBox(
                    child: Icon(
                      HelperIcons.getIconData(helpericons[i].toString()),
                      color: Colors.white,
                      size: 25,
                    ),
                  )),
              onTap: () {
                print(helpericons[i].toString());
                print(ref.watch(provCat).icon);
                //ref.watch(provCat).setIcon(icons[i].toString());
                ref.watch(provCat).setIcon(helpericons[i].toString());
                Navigator.pop(context);
              },
            ),
            // Icon(icons[i]),
          );
        }),
      ),
    );
  }
}

