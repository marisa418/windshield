import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_simple_calculator/src/calc_controller.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/utility/number_formatter.dart';

class CreateBalance extends ConsumerWidget {
  const CreateBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(provBSheet.select((e) => e.createIdx));

    return idx == 0 ? const ChoseCat() : const InputForm();
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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "เลือกประเภทสินทรัพย์",
              style: MyTheme.whiteTextTheme.headline2,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: Text(
                  getname(catList[0].ftype),
                  style: MyTheme.textTheme.headline3,
                ),
              ),
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
                              height:
                                  60, //height of button แก้ตอนเลือกประเภท overflow
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
                        AutoSizeText(
                          catList[i].name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          minFontSize: 0,
                        ),
                      ],
                    ),
                  );
                },
              ),
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
    if (ftype == '7' || ftype == '8' || ftype == '9') {
      return const AssetForm();
    } else {
      return const DebtForm();
    }
  }
}

class AssetForm extends ConsumerStatefulWidget {
  const AssetForm({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AssetFormState();
}

class _AssetFormState extends ConsumerState<AssetForm> {
  final _controller = CalcController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cat = ref.watch(provBSheet.select((e) => e.currCat));
    final value = ref.watch(provBSheet.select((e) => e.value));
    final source = ref.watch(provBSheet.select((e) => e.source));
    final isCalc = ref.watch(provBSheet.select((e) => e.isCalc));
    return WillPopScope(
      onWillPop: () async {
        if (isCalc) {
          ref.read(provBSheet).setIsCalc(false);
          return false;
        }
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: getcolor(cat.ftype),
              borderRadius: const BorderRadius.only(
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
                                    AutoSizeText(
                                      value == 0
                                          ? 'โปรดกรอกจำนวนเงิน'
                                          : HelperNumber.format(value),
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      style: value == 0
                                          ? MyTheme.textTheme.headline3!.merge(
                                              const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            )
                                          : MyTheme.textTheme.headline3,
                                    ),
                                    AutoSizeText(
                                      _controller.expression ?? '',
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: MyTheme.textTheme.bodyText2!.merge(
                                        const TextStyle(color: Colors.grey),
                                      ),
                                    ),
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
                              color: getcolor(cat.ftype),
                            ),
                            child: Icon(
                              HelperIcons.getIconData(cat.icon),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: isCalc
                        ? SimpleCalculator(
                            hideSurroundingBorder: true,
                            controller: _controller,
                            theme: CalculatorThemeData(
                              displayStyle: const TextStyle(
                                fontSize: 0,
                                color: Colors.white,
                              ),
                              expressionStyle: const TextStyle(fontSize: 0),
                              commandColor: MyTheme.primaryMajor,
                              commandStyle: MyTheme.whiteTextTheme.headline4,
                              operatorColor: MyTheme.primaryMinor,
                              operatorStyle:
                                  MyTheme.whiteTextTheme.headline2!.merge(
                                TextStyle(color: MyTheme.primaryMajor),
                              ),
                              // numStyle:
                            ),
                            onChanged: (_, value, __) {
                              ref
                                  .read(provBSheet)
                                  .setValue(_controller.value ?? 0);
                            },
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 30),
                              TextFormField(
                                initialValue: source,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'เข้าถึงสินทรัพย์นี้ผ่าน',
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
                                  ref.read(provBSheet).setSource(e);
                                },
                              ),
                              Expanded(child: Container()),
                              //บันทึกลงฟอร์ม
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (ref.watch(
                                        provBSheet.select((e) => e.isAdd))) {
                                      final asset =
                                          await ref.read(apiProvider).addAsset(
                                                ref.read(provBSheet).source,
                                                ref.read(provBSheet).value,
                                                ref.read(provBSheet).currCat.id,
                                              );
                                      if (asset) {
                                        ref.read(provBSheet).setNeedFetchAPI();
                                        AutoRouter.of(context).pop();
                                      }
                                    } else {
                                      final asset =
                                          await ref.read(apiProvider).editAsset(
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
                              const SizedBox(height: 15),
                              //ลบออก
                              if (ref.watch(provBSheet.select((e) => !e.isAdd)))
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final asset = await ref
                                          .read(apiProvider)
                                          .deleteAsset(
                                            ref.read(provBSheet).source,
                                            ref.read(provBSheet).value,
                                            ref.read(provBSheet).id,
                                          );
                                      if (asset) {
                                        ref.read(provBSheet).setNeedFetchAPI();
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
      ),
    );
  }
}

class DebtForm extends ConsumerStatefulWidget {
  const DebtForm({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DebtFormState();
}

class _DebtFormState extends ConsumerState<DebtForm> {
  final _controller = CalcController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cat = ref.watch(provBSheet.select((e) => e.currCat));
    final balance = ref.watch(provBSheet.select((e) => e.balance));
    final creditor = ref.watch(provBSheet.select((e) => e.creditor));
    final interest = ref.watch(provBSheet.select((e) => e.interest));
    final debtTerm = ref.watch(provBSheet.select((e) => e.debtTerm));
    final isCalc = ref.watch(provBSheet.select((e) => e.isCalc));
    return WillPopScope(
      onWillPop: () async {
        if (isCalc) {
          ref.read(provBSheet).setIsCalc(false);
          return false;
        }
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: getcolor(cat.ftype),
              borderRadius: const BorderRadius.only(
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
                                    AutoSizeText(
                                      balance == 0
                                          ? 'ยอดคงเหลือ บ.'
                                          : HelperNumber.format(balance),
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      style: balance == 0
                                          ? MyTheme.textTheme.headline3!.merge(
                                              const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            )
                                          : MyTheme.textTheme.headline3,
                                    ),
                                    AutoSizeText(
                                      _controller.expression ?? '',
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: MyTheme.textTheme.bodyText2!.merge(
                                        const TextStyle(color: Colors.grey),
                                      ),
                                    ),
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
                              color: getcolor(cat.ftype),
                            ),
                            child: Icon(
                              HelperIcons.getIconData(cat.icon),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: isCalc
                        ? SimpleCalculator(
                            hideSurroundingBorder: true,
                            controller: _controller,
                            theme: CalculatorThemeData(
                              displayStyle: const TextStyle(
                                fontSize: 0,
                                color: Colors.white,
                              ),
                              expressionStyle: const TextStyle(fontSize: 0),
                              commandColor: MyTheme.primaryMajor,
                              commandStyle: MyTheme.whiteTextTheme.headline4,
                              operatorColor: MyTheme.primaryMinor,
                              operatorStyle:
                                  MyTheme.whiteTextTheme.headline2!.merge(
                                TextStyle(color: MyTheme.primaryMajor),
                              ),
                              // numStyle:
                            ),
                            onChanged: (_, value, __) {
                              ref
                                  .read(provBSheet)
                                  .setBalance(_controller.value ?? 0);
                            },
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 30),
                              TextFormField(
                                initialValue: creditor,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'เจ้าหนี้',
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
                                  ref.read(provBSheet).setCreditor(e);
                                },
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                initialValue:
                                    interest == 0 ? '' : interest.toString(),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'ดอกเบี้ย %',
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
                                  ref
                                      .read(provBSheet)
                                      .setInterest(double.tryParse(e) ?? 0);
                                },
                              ),
                              const SizedBox(height: 30),
                              GestureDetector(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) => Center(
                                      child: Container(
                                        //ปรับขนาดปฏิทิน
                                        height: 500,
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        color: Colors.white,
                                        child: CupertinoDatePicker(
                                          initialDateTime: DateTime.now(),
                                          mode: CupertinoDatePickerMode.date,
                                          use24hFormat: true,
                                          // This is called when the user changes the date.
                                          onDateTimeChanged:
                                              (DateTime newDate) {
                                            ref
                                                .read(provBSheet)
                                                .setDebtTerm(newDate);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    debtTerm != null
                                        ? DateFormat.yMMMMd().format(debtTerm)
                                        : 'ต้องชำระให้หมดภายใน',
                                    style: debtTerm != null
                                        ? MyTheme.textTheme.bodyText1
                                        : MyTheme.textTheme.bodyText1!.merge(
                                            TextStyle(
                                              color:
                                                  Colors.black.withOpacity(.5),
                                            ),
                                          ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              //บันทึกลงฟอร์ม
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (ref.watch(
                                        provBSheet.select((e) => e.isAdd))) {
                                      final asset =
                                          await ref.read(apiProvider).addDebt(
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
                                      final asset =
                                          await ref.read(apiProvider).editDebt(
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
                              if (ref.watch(provBSheet.select((e) => !e.isAdd)))
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final asset = await ref
                                          .read(apiProvider)
                                          .deleteDebt(
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
      ),
    );
  }
}

//change type
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
    return 'สินทรัพย์ลงทุน';
  } else if (value == '9') {
    return 'สินทรัพย์ส่วนตัว';
  } else if (value == '10') {
    return 'หนี้สินระยะสั้น';
  } else {
    return 'หนี้สินระยะยาว';
  }
}
