import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:windshield/main.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';
import 'budget_provider.dart';

final provBud = ChangeNotifierProvider.autoDispose<BudgetProvider>(
    (ref) => BudgetProvider());

final apiBud = FutureProvider.autoDispose<void>((ref) async {
  final data = await ref.read(apiProvider).analBudget();
  ref.read(provBud).setStatementList(data);
});

class BudgetTab extends ConsumerWidget {
  const BudgetTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statementList = ref.watch(provBud).statementList;
    final api = ref.watch(apiBud);

    return api.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (_) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'สรุปการเงินที่ผ่านมา',
                style: MyTheme.textTheme.headline4!.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              for (var i = 0; i < statementList.length; i++) ...[
                StatementItem(i: i),
                const SizedBox(height: 20),
              ],
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class StatementItem extends ConsumerWidget {
  const StatementItem({required this.i, Key? key}) : super(key: key);

  final int i;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provBud.select((e) => e.statementList[i]));
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            blurRadius: 4,
            offset: const Offset(0, 0), // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Text(
                  state.name,
                  style: MyTheme.textTheme.bodyText1!.merge(
                    const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Flexible(
                flex: 6,
                fit: FlexFit.tight,
                child: AutoSizeText(
                  '${DateFormat('d MMM y').format(state.start)} - ${DateFormat('d MMM y').format(state.end)}',
                  textAlign: TextAlign.right,
                  minFontSize: 0,
                  maxLines: 1,
                  style: MyTheme.textTheme.bodyText1!.merge(
                    TextStyle(color: MyTheme.primaryMajor),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400],
            height: 36,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'สภาพคล่องสุทธิ',
                  style: MyTheme.textTheme.headline4,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: HelperNumber.format((state.incWorkingFlow +
                                state.incAssetFlow +
                                state.incOtherFlow) -
                            (state.expInConsistFlow +
                                state.expConsistFlow +
                                state.savInvFlow)),
                        style: MyTheme.textTheme.headline3!.merge(
                          TextStyle(
                            color: MyTheme.negativeMajor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextSpan(
                        text:
                            "/${HelperNumber.format((state.incWorkingBud + state.incAssetBud + state.incOtherBud) - (state.expInConsistBud + state.expConsistBud + state.savInvBud))}",
                        style: MyTheme.textTheme.headline3!.merge(
                          TextStyle(
                            color: MyTheme.negativeMajor.withOpacity(.3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: "บ.",
                        style: MyTheme.textTheme.headline3!.merge(
                          TextStyle(
                            color: MyTheme.negativeMajor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'รายรับ',
                  style: MyTheme.textTheme.headline4,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: HelperNumber.format(
                        state.incWorkingFlow +
                            state.incAssetFlow +
                            state.incOtherFlow,
                      ),
                      style: MyTheme.textTheme.headline4!.merge(
                        TextStyle(
                          color: MyTheme.positiveMajor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: '/${HelperNumber.format(
                        state.incWorkingBud +
                            state.incAssetBud +
                            state.incOtherBud,
                      )}',
                      style: MyTheme.textTheme.headline4!.merge(
                        TextStyle(
                          color: MyTheme.positiveMajor.withOpacity(.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: " บ.",
                      style: MyTheme.textTheme.headline4!.merge(
                        TextStyle(
                          color: MyTheme.positiveMajor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Progress(
            bud: state.incWorkingBud,
            flow: state.incWorkingFlow,
            ftype: 'รายรับจากการทำงาน',
            color: MyTheme.incomeWorking,
          ),
          const SizedBox(height: 10),
          Progress(
            bud: state.incAssetBud,
            flow: state.incAssetFlow,
            ftype: 'รายรับจากสินทรัพย์',
            color: MyTheme.incomeAsset,
          ),
          const SizedBox(height: 10),
          Progress(
            bud: state.incOtherBud,
            flow: state.incOtherFlow,
            ftype: 'รายรับอื่นๆ',
            color: MyTheme.incomeOther,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'รายจ่าย',
                  style: MyTheme.textTheme.headline4,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: HelperNumber.format(
                        state.expInConsistFlow +
                            state.expConsistFlow +
                            state.savInvFlow,
                      ),
                      style: MyTheme.textTheme.headline4!.merge(
                        TextStyle(
                          color: MyTheme.negativeMajor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: '/${HelperNumber.format(
                        state.expInConsistBud +
                            state.expConsistBud +
                            state.savInvBud,
                      )}',
                      style: MyTheme.textTheme.headline4!.merge(
                        TextStyle(
                          color: MyTheme.negativeMajor.withOpacity(.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: " บ.",
                      style: MyTheme.textTheme.headline4!.merge(
                        TextStyle(
                          color: MyTheme.negativeMajor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Progress(
            bud: state.expInConsistBud,
            flow: state.expInConsistFlow,
            ftype: 'รายจ่ายไม่คงที่',
            color: MyTheme.expenseInconsist,
          ),
          const SizedBox(height: 10),
          Progress(
            bud: state.expConsistBud,
            flow: state.expConsistFlow,
            ftype: 'รายจ่ายคงที่',
            color: MyTheme.expenseConsist,
          ),
          const SizedBox(height: 10),
          Progress(
            bud: state.savInvBud,
            flow: state.savInvFlow,
            ftype: 'การออมและการลงทุน',
            color: MyTheme.savingAndInvest,
          ),
          const SizedBox(height: 20),
          Text(
            'ประเมินการปฎิบัติตามแผน',
            style: MyTheme.textTheme.headline3!.merge(
              const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'การทำบัญชีรายรับ-รายจ่าย',
                style: MyTheme.textTheme.headline4!.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: state.count.toString(),
                      style: TextStyle(
                        color: MyTheme.primaryMajor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "/${state.end.difference(state.start).inDays + 1} ",
                      style: TextStyle(
                        color: MyTheme.primaryMajor.withOpacity(.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: "วัน",
                      style: TextStyle(
                        color: MyTheme.primaryMajor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Progress extends StatelessWidget {
  const Progress({
    required this.bud,
    required this.flow,
    required this.ftype,
    required this.color,
    Key? key,
  }) : super(key: key);

  final String ftype;
  final List<Color> color;
  final double bud;
  final double flow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ftype,
              style: MyTheme.textTheme.bodyText1,
            ),
            Text(
              'ดูเพิ่มเติม ',
              style: TextStyle(
                fontSize: 12,
                color: MyTheme.primaryMajor,
              ),
            ),
          ],
        ),
        LinearPercentIndicator(
          lineHeight: 16.0,
          percent: HelperProgress.getPercent(flow, bud),
          animation: true,
          animationDuration: 2500,
          backgroundColor: color[1],
          progressColor: color[0],
          padding: const EdgeInsets.all(0),
          center: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: HelperNumber.format(flow),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "/${HelperNumber.format(bud)} ",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const TextSpan(
                      text: "บ.",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          barRadius: const Radius.circular(20),
        ),
      ],
    );
  }
}
