import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:windshield/main.dart';
import 'package:windshield/models/balance_sheet/balance_sheet.dart';
import 'package:windshield/models/daily_flow/flow.dart';
import 'package:windshield/styles/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:badges/badges.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:flutter/cupertino.dart';

class CreateBalance extends ConsumerWidget {
  const CreateBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(provBSheet.select((e) => e.createIdx));

    return idx == 0 ? ChoseCat() : InputForm();
  }
}

class ChoseCat extends ConsumerWidget {
  const ChoseCat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catList = ref.watch(provBSheet.select((e) => e.createCatList));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: getcolor(catList[0].ftype),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("เลือกประเภทสินทรัพย์",
                style: MyTheme.whiteTextTheme.headline2),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getname(catList[0].ftype),
                  style: MyTheme.textTheme.headline3),
              GridView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: catList.length,
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
                                height: 75, //height of button
                                width: 75, //width of button
                                child: ElevatedButton(
                                  onPressed: () {
                                    ref.read(provBSheet).setCurrCat(catList[i]);
                                    ref.read(provBSheet).setCreateIdx(1);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    //elevation: 0.0,
                                    //shadowColor: Colors
                                    //    .transparent, //remove shadow on button
                                    primary: getcolor(catList[i].ftype),
                                    textStyle: MyTheme.whiteTextTheme.headline4,
                                    padding: const EdgeInsets.all(10),

                                    shape: const CircleBorder(),
                                  ),
                                  child: Icon(
                                    HelperIcons.getIconData(catList[i].icon),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(catList[i].name)
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

class InputForm extends ConsumerWidget {
  const InputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ftype = ref.watch(provBSheet.select((e) => e.currCat.ftype));
    print(ftype);
    if (ftype == '7' || ftype == '8' || ftype == '9') {
      return AssetForm();
    } else {
      return DebtForm();
    }
  }
}

class AssetForm extends ConsumerWidget {
  const AssetForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = ref.watch(provBSheet.select((e) => e.currCat));
    final value = ref.watch(provBSheet.select((e) => e.value));
    final source = ref.watch(provBSheet.select((e) => e.source));
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: getcolor(cat.ftype),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(cat.name, style: MyTheme.whiteTextTheme.headline3),
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
                          color: getcolor(cat.ftype),
                        ),
                        child: Icon(
                          HelperIcons.getIconData(cat.icon),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          //value : value,
                          initialValue: value == 0 ? '' : value.toString(),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration.collapsed(
                            hintText: 'มูลค่าในปัจจุบัน บ.',
                            fillColor: Colors.grey.withOpacity(0.2),
                            filled: true,
                          ),
                          onChanged: (e) {
                            ref
                                .read(provBSheet)
                                .setValue(double.tryParse(e) ?? 0);
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    //value : value,
                    initialValue: source,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration.collapsed(
                      hintText: 'เข้าถึงสินทรัพย์นี้ผ่าน',
                      fillColor: Colors.grey.withOpacity(0.2),
                      filled: true,
                    ),
                    onChanged: (e) {
                      ref.read(provBSheet).setSource(e);
                    },
                  ),
                  //บันทึกลงฟอร์ม
                  ElevatedButton(
                    onPressed: () async {
                      if (ref.watch(provBSheet.select((e) => e.isAdd))) {
                        final asset = await ref.read(apiProvider).addAsset(
                              ref.read(provBSheet).source,
                              ref.read(provBSheet).value,
                              ref.read(provBSheet).currCat.id,
                            );
                        if (asset) {
                          ref.read(provBSheet).setNeedFetchAPI();
                          AutoRouter.of(context).pop();
                        }
                      } else {
                        final asset = await ref.read(apiProvider).editAsset(
                              ref.read(provBSheet).source,
                              ref.read(provBSheet).value,
                              ref.read(provBSheet).id,
                            );
                        if (asset) {
                          ref.read(provBSheet).setNeedFetchAPI();
                          AutoRouter.of(context).pop();
                        }
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child:
                        Text('บันทึก', style: MyTheme.whiteTextTheme.headline3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DebtForm extends ConsumerWidget {
  const DebtForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = ref.watch(provBSheet.select((e) => e.currCat));
    final balance = ref.watch(provBSheet.select((e) => e.balance));
    final creditor = ref.watch(provBSheet.select((e) => e.creditor));
    final interest = ref.watch(provBSheet.select((e) => e.interest));
    final debtTerm = ref.watch(provBSheet.select((e) => e.debtTerm));
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: getcolor(cat.ftype),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(cat.name, style: MyTheme.whiteTextTheme.headline3),
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
                          color: getcolor(cat.ftype),
                        ),
                        child: Icon(
                          HelperIcons.getIconData(cat.icon),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          //value : value,
                          initialValue: balance == 0 ? '' : balance.toString(),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration.collapsed(
                            hintText: 'ยอดคงเหลือ บ.',
                            fillColor: Colors.grey.withOpacity(0.2),
                            filled: true,
                          ),
                          onChanged: (e) {
                            ref
                                .read(provBSheet)
                                .setBalance(double.tryParse(e) ?? 0);
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    //value : value,
                    initialValue: creditor,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration.collapsed(
                      hintText: 'เจ้าหนี้',
                      fillColor: Colors.grey.withOpacity(0.2),
                      filled: true,
                    ),
                    onChanged: (e) {
                      ref.read(provBSheet).setCreditor(e);
                    },
                  ),

                  TextFormField(
                    //value : value,
                    initialValue: interest == 0 ? '' : interest.toString(),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration.collapsed(
                      hintText: 'ดอกเบี้ย %',
                      fillColor: Colors.grey.withOpacity(0.2),
                      filled: true,
                    ),
                    onChanged: (e) {
                      ref.read(provBSheet).setInterest(double.tryParse(e) ?? 0);
                    },
                  ),
                  GestureDetector(
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) => Center(
                            child: Container(
                              //ปรับขนาดปฏิทิน
                              height: 500,
                              padding: const EdgeInsets.only(top: 6.0),
                              // The Bottom margin is provided to align the popup above the system navigation bar.
                              // margin: EdgeInsets.only(
                              //   bottom: MediaQuery.of(context)
                              //       .viewInsets
                              //       .bottom,
                              // ),
                              color: Colors.white,
                              // Provide a background color for the popup.
                              // Use a SafeArea widget to avoid system overlaps.
                              child: CupertinoDatePicker(
                                initialDateTime: DateTime.now(),
                                mode: CupertinoDatePickerMode.date,
                                use24hFormat: true,
                                // This is called when the user changes the date.
                                onDateTimeChanged: (DateTime newDate) {
                                  ref.read(provBSheet).setDebtTerm(newDate);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(debtTerm != null
                          ? DateFormat.yMMMMd().format(debtTerm)
                          : 'ต้องชำระให้หมดภายใน')),

                  //บันทึกลงฟอร์ม
                  ElevatedButton(
                    onPressed: () async {
                      if (ref.watch(provBSheet.select((e) => e.isAdd))) {
                        final asset = await ref.read(apiProvider).addDebt(
                              ref.read(provBSheet).balance,
                              ref.read(provBSheet).creditor,
                              ref.read(provBSheet).currCat.id,
                              ref.read(provBSheet).interest,
                              ref.read(provBSheet).debtTerm,
                            );
                        if (asset) {
                          ref.read(provBSheet).setNeedFetchAPI();
                          AutoRouter.of(context).pop();
                        }
                      } else {
                        final asset = await ref.read(apiProvider).editDebt(
                              ref.read(provBSheet).balance,
                              ref.read(provBSheet).creditor,
                              ref.read(provBSheet).id,
                              ref.read(provBSheet).interest,
                              ref.read(provBSheet).debtTerm,
                            );
                        if (asset) {
                          ref.read(provBSheet).setNeedFetchAPI();
                          AutoRouter.of(context).pop();
                        }
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child:
                        Text('บันทึก', style: MyTheme.whiteTextTheme.headline3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color getcolor(String value) {
  if (value == '7') {
    return MyTheme.assetLiquid[0];
  } else if (value == '8') {
    return MyTheme.assetInvest[0];
  } else if (value == '9') {
    return MyTheme.assetPersonal[0];
  } else if (value == '10') {
    return MyTheme.debtShort[0];
  } else {
    return MyTheme.debtLong[0];
  }
}

String getname(String value) {
  if (value == '7') {
    return 'สินทรัพย์สภาพคล่อง';
  } else if (value == '8') {
    return 'สินทรัพย์สภาพคล่อง';
  } else if (value == '9') {
    return 'สินทรัพย์สภาพคล่อง';
  } else if (value == '10') {
    return 'สินทรัพย์สภาพคล่อง';
  } else {
    return 'สินทรัพย์สภาพคล่อง';
  }
}
