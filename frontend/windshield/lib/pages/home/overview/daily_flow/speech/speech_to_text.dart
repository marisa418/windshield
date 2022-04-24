import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:windshield/components/loading.dart';

import 'package:windshield/main.dart';
import 'package:windshield/pages/home/overview/daily_flow/overview/daily_flow_overview_page.dart';
import 'package:windshield/providers/speech_to_text_provider.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';
import '../daily_flow_page.dart';
import 'cat_type.dart';

final provSpeech = ChangeNotifierProvider.autoDispose<SpeechToTextProvider>(
    (ref) => SpeechToTextProvider());

class SpeechToTextPage extends ConsumerStatefulWidget {
  const SpeechToTextPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpeechToTextPageState();
}

class _SpeechToTextPageState extends ConsumerState<SpeechToTextPage> {
  @override
  void initState() {
    super.initState();
    final id = ref.read(provOverFlow).dfId;
    ref.read(provSpeech).initSpeechState();
    ref.read(provSpeech).setDfId(id);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(provSpeech);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: const [
            Header(),
            FlowList(),
            Footer(),
          ],
        ),
      ),
    );
  }
}

class Header extends ConsumerWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(provOverFlow.select((e) => e.pageIdx));
    final isListening =
        ref.watch(provSpeech.select((e) => e.speech.isListening));
    final hasSpeech = ref.watch(provSpeech.select((e) => e.hasSpeech));
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              idx == 0 ? MyTheme.incomeBackground : MyTheme.expenseBackground,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              AutoRouter.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 315.0),
              child: Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
          isListening
              ? Text(
                  "ฉันกำลังฟัง...",
                  style: MyTheme.whiteTextTheme.headline4,
                )
              : Column(
                  children: [
                    Text(
                      'กดข้างล่างเพื่อเพิ่มรายการ',
                      style: MyTheme.whiteTextTheme.headline4,
                    ),
                  ],
                ),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white.withOpacity(.3),
            ),
            child: GestureDetector(
              onTap: () {
                if (hasSpeech && !isListening) {
                  ref.read(provSpeech).startListening();
                } else if (hasSpeech && isListening) {
                  ref.read(provSpeech).cancelListening();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ref.watch(provSpeech).lastWords != ''
                    ? Text(
                        ref.watch(provSpeech).lastWords,
                        style: MyTheme.whiteTextTheme.headline4,
                        textAlign: TextAlign.center,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.mic, color: Colors.white),
                          Text(
                            'ชื่อรายการ ราคา (บาท) (วิธีชำระ)',
                            style: MyTheme.whiteTextTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FlowList extends ConsumerWidget {
  const FlowList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provSpeech);
    final flowList = ref.watch(provSpeech.select((e) => e.flowList));
    final idx = ref.watch(provOverFlow.select((e) => e.pageIdx));
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView.separated(
          physics: const ScrollPhysics(),
          itemCount: flowList.length,
          shrinkWrap: true,
          separatorBuilder: (_, i) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () {
                ref.read(provSpeech).setFlowIdx(i);
                ref.read(provSpeech).setName(flowList[i].name);
                ref.read(provSpeech).setValue(flowList[i].value);
                ref.read(provSpeech).setMethod(flowList[i].method);

                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => const Calculator(),
                );
              },
              child: Container(
                height: 100,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: MyTheme.dropShadow,
                      blurRadius: 1,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: Slidable(
                  key: Key(flowList[i].key),
                  endActionPane: ActionPane(
                    extentRatio: 0.25,
                    motion: const BehindMotion(),
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              useRootNavigator: false,
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('ท่านยืนยันที่จะลบหรือไม่?'),
                                actions: [
                                  TextButton(
                                    child: const Text('ยกเลิก'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: const Text('ยืนยัน'),
                                    onPressed: () {
                                      ref.read(provSpeech).removeFlow(i);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: MyTheme.expenseBackground,
                              ),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                Text('ลบ',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: GestureDetector(
                            onTap: () {
                              ref.read(provSpeech).setFlowIdx(i);
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (_) => const ChooseCat(),
                              );
                            },
                            child: Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: flowList[i].cat.id == ''
                                    ? Colors.grey.shade200
                                    : flowList[i].cat.color,
                              ),
                              child: Icon(
                                flowList[i].cat.id == ''
                                    ? FontAwesomeIcons.question
                                    : HelperIcons.getIconData(
                                        flowList[i].cat.icon),
                                color: flowList[i].cat.id == ''
                                    ? Colors.grey.shade500
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    flowList[i].name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 10,
                                    children: [
                                      Icon(
                                        getIcon(flowList[i].method),
                                        size: 15,
                                        color: flowList[i].cat.id == ''
                                            ? (idx == 0
                                                ? MyTheme.positiveMajor
                                                : MyTheme.negativeMajor)
                                            : flowList[i].cat.color,
                                      ),
                                      Text(
                                        getMethod(flowList[i].method),
                                        style: TextStyle(
                                          color: flowList[i].cat.id == ''
                                              ? (idx == 0
                                                  ? MyTheme.positiveMajor
                                                  : MyTheme.negativeMajor)
                                              : flowList[i].cat.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                '${flowList[i].value.toString()} บ.',
                                style: MyTheme.textTheme.headline2!.merge(
                                  TextStyle(
                                    color: flowList[i].cat.id == ''
                                        ? (idx == 0
                                            ? MyTheme.positiveMajor
                                            : MyTheme.negativeMajor)
                                        : flowList[i].cat.color,
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
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChooseCat extends ConsumerWidget {
  const ChooseCat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(provOverFlow.select((e) => e.pageIdx));
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 17,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: idx == 0 ? MyTheme.positiveMajor : MyTheme.negativeMajor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Text(
                'เลือกหมวดหมู่ราย${idx == 0 ? "รับ" : "จ่าย"}',
                style: MyTheme.whiteTextTheme.headline3,
              ),
            ),
          ),
          Flexible(
            flex: 83,
            fit: FlexFit.tight,
            child: Container(
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: const CatList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CatList extends ConsumerWidget {
  const CatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(provOverFlow.select((e) => e.pageIdx));
    if (idx == 0) {
      return ListView(
        shrinkWrap: true,
        children: [
          Text('รายรับจากการทำงาน', style: MyTheme.textTheme.headline4),
          const SizedBox(height: 15),
          const IncWorkingList(),
          const SizedBox(height: 30),
          Text('รายรับจากสินทรัพย์', style: MyTheme.textTheme.headline4),
          const SizedBox(height: 15),
          const IncAssetList(),
          const SizedBox(height: 30),
          Text('รายรับอื่นๆ', style: MyTheme.textTheme.headline4),
          const SizedBox(height: 15),
          const IncOtherList(),
        ],
      );
    } else {
      return ListView(
        shrinkWrap: true,
        children: [
          Text('รายจ่ายไม่คงที่', style: MyTheme.textTheme.headline4),
          const SizedBox(height: 15),
          const ExpInconList(),
          const SizedBox(height: 30),
          Text('รายจ่ายคงที่', style: MyTheme.textTheme.headline4),
          const SizedBox(height: 15),
          const ExpConList(),
          const SizedBox(height: 30),
          Text('การออมและการลงทุน', style: MyTheme.textTheme.headline4),
          const SizedBox(height: 15),
          const SavInvList(),
        ],
      );
    }
  }
}

class Calculator extends ConsumerWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(provSpeech.select((e) => e.name));
    final value = ref.watch(provSpeech.select((e) => e.value));
    final method = ref.watch(provSpeech.select((e) => e.method));
    final idx = ref.watch(provOverFlow.select((e) => e.pageIdx));
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: idx == 0 ? MyTheme.positiveMajor : MyTheme.negativeMajor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: TextFormField(
                initialValue: name,
                onChanged: (e) {
                  ref.read(provSpeech).setName(e);
                },
                style: MyTheme.whiteTextTheme.headline4,
                showCursor: false,
                decoration: const InputDecoration(
                  icon: Icon(Icons.edit, color: Colors.white),
                  hintText: 'โปรดกรอกชื่อรายการ',
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 6,
                  child: TextFormField(
                    initialValue: value.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (e) =>
                        ref.read(provSpeech).setValue(double.tryParse(e) ?? 0),
                    decoration: InputDecoration(
                      hintText: 'โปรดกรอกจำนวนเงิน',
                      contentPadding: const EdgeInsets.all(10),
                      fillColor: Colors.grey.withOpacity(.15),
                      filled: true,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.none),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.none),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: DropdownButtonFormField<int>(
                    style: MyTheme.textTheme.bodyText1!.merge(
                      TextStyle(
                        color: idx == 0
                            ? MyTheme.positiveMajor
                            : MyTheme.negativeMajor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    value: method,
                    isExpanded: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        getIcon(method),
                        size: 14,
                        color: idx == 0
                            ? MyTheme.positiveMajor
                            : MyTheme.negativeMajor,
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.3),
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.3),
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    iconSize: 0,
                    onChanged: (e) => ref.read(provSpeech).setMethod(e!),
                    items: <String>['เงินสด', 'โอน', 'บัตรเครดิต']
                        .map<DropdownMenuItem<int>>((String value) {
                      return DropdownMenuItem<int>(
                        value: _returnType(value),
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

IconData getIcon(int value) {
  if (value == 2) return FontAwesomeIcons.moneyBill;
  if (value == 3) return FontAwesomeIcons.exchangeAlt;
  return FontAwesomeIcons.creditCard;
}

String getMethod(int value) {
  if (value == 2) return 'เงินสด';
  if (value == 3) return 'โอน';
  return 'บัตรเครดิต';
}

int _returnType(String value) {
  if (value == 'เงินสด') return 2;
  if (value == 'โอน') return 3;
  return 4;
}

class Footer extends ConsumerWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provSpeech);
    final idx = ref.watch(provOverFlow.select((e) => e.pageIdx));
    final flowList = ref.watch(provSpeech.select((e) => e.flowList));
    return Container(
      height: 100,
      padding: const EdgeInsets.all(15),
      // margin: const EdgeInsets.only(top: 10.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              idx == 0 ? MyTheme.positiveMinor : MyTheme.negativeMinor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          minimumSize: const Size(double.infinity, double.infinity),
        ),
        // onPressed: () => ref.read(provSpeech).addFlowList(),
        onPressed: () async {
          if (flowList.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('กรุณาสร้างอย่างน้อยหนึ่งรายการ')),
            );
          } else if (flowList.any((e) => e.cat.id == '')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('กรุณากำหนดหมวดหมู่ให้ครบถ้วน')),
            );
            return;
          } else {
            showLoading(context);
            final flow = await ref.read(apiProvider).addFlowList(flowList);
            if (flow) {
              ref.read(provDFlow).setNeedFetchAPI();
              ref.read(provOverFlow).setNeedFetchAPI();
              ref.refresh(apiDateChange);
              AutoRouter.of(context).popUntilRouteWithName('DailyFlowRoute');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('เกิดข้อผิดพลาด')),
              );
              AutoRouter.of(context).pop();
            }
          }
        },
        child: Text(
          '+ ${flowList.length} รายการ',
          style: MyTheme.textTheme.headline3!.merge(
            TextStyle(
              color: idx == 0 ? MyTheme.positiveMajor : MyTheme.negativeMajor,
            ),
          ),
        ),
      ),
    );
  }
}
