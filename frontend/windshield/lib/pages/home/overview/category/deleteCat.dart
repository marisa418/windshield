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


class InputCatForm extends ConsumerWidget {
  const InputCatForm({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curCat = ref.watch(provCat.select((e) => e.currCat)); 
    return Container(
      color: Colors.white,
      
      child: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              
              borderRadius: BorderRadius.only(
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
                  Row(
                    children: [
                      Container(
                        height: 75, //height of button
                        width: 75, //width of button
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Icon(
                          HelperIcons.getIconData(curCat.icon),
                        ),
                        
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:Text(curCat.name, style:MyTheme.textTheme.headline3),
                          ),
                        ]
                        
                      ),
                    ],
                  ),
                 
                  
                  //ลบออก
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final asset = await ref.read(apiProvider).deleteCategory(
                              
                              ref.read(provCat).id,
                              
                            );
                        if (asset) {
                          ref.read(provCat).setNeedFetchAPI();
                          AutoRouter.of(context).pop();
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      child: Text('ลบ', style: MyTheme.whiteTextTheme.headline3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class Testform extends ConsumerWidget {
  const Testform({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curCat = ref.watch(provCat.select((e) => e.currCat)); 
    final curFtype = ref.watch(provCat.select((e) => e.curFtype));
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: HelperColor.getFtColor(curFtype, 0),
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
                          child: GestureDetector(
                            onTap: () => ref.read(provBSheet).setIsCalc(true),
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
                                  children: [
                                    
                                    
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 75, //height of button
                            width: 75, //width of button
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HelperColor.getFtColor(curFtype, 0),
                            ),
                            child: Icon(
                              HelperIcons.getIconData(curCat.icon),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: 
                         Column(
                            children: [
                              const SizedBox(height: 30),
                              TextFormField(
                                initialValue: curCat.name,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'CurCat.name',
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
                              const SizedBox(height: 30),
                              
                              const SizedBox(height: 30),
                              
                              Expanded(child: Container()),
                              //บันทึกลงฟอร์ม
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 50,
                                child: ElevatedButton(
                                  onPressed: () async {
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
                                      if (asset) {
                                        ref.read(provCat).setNeedFetchAPI();
                                        AutoRouter.of(context).pop();
                                      }
                                    } else {
                                      final asset =
                                          await ref.read(apiProvider).editCategory(
                                                ref.read(provCat).id,
                                                ref.read(provCat).name,
                                                ref.read(provCat).icon,
                                                
                                              );
                                      if (asset) {
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
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  child: Text('บันทึก',
                                      style: MyTheme.whiteTextTheme.headline3),
                                ),
                              ),
                              //ลบออก
                              if (ref.watch(provCat.select((e) => !e.isAdd)))
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 50,
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
                                              BorderRadius.circular(18.0),
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


class Test2Form extends ConsumerStatefulWidget {
  const Test2Form({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestFormState();
}

class _TestFormState extends ConsumerState<Test2Form> {
  //final _controller = CalcController();
  /*
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    final curCat = ref.watch(provCat.select((e) => e.currCat)); 
    final curFtype = ref.watch(provCat.select((e) => e.curFtype));
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: HelperColor.getFtColor(curFtype, 0),
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
                          child: GestureDetector(
                            onTap: () => ref.read(provBSheet).setIsCalc(true),
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
                                  children: [
                                    
                                    
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 75, //height of button
                            width: 75, //width of button
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HelperColor.getFtColor(curFtype, 0),
                            ),
                            child: Icon(
                              HelperIcons.getIconData(curCat.icon),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: 
                         Column(
                            children: [
                              const SizedBox(height: 30),
                              TextFormField(
                                initialValue: curCat.name,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'CurCat.name',
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
                              const SizedBox(height: 30),
                              
                              const SizedBox(height: 30),
                              
                              Expanded(child: Container()),
                              //บันทึกลงฟอร์ม
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    ref.read(provCat).setIcon('flag_sharp');
                                    ref.read(provCat).setFtype('1');
                                    if (ref.watch(
                                        provCat.select((e) => e.isAdd))) {
                                      final asset =
                                          await ref.read(apiProvider).addCategory(
                                                ref.read(provCat).name,
                                                ref.read(provCat).icon.toString(),
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
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  child: Text('บันทึก',
                                      style: MyTheme.whiteTextTheme.headline3),
                                ),
                              ),
                              //ลบออก
                              if (ref.watch(provCat.select((e) => !e.isAdd)))
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 50,
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
                                              BorderRadius.circular(18.0),
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
