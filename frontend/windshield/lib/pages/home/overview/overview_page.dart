import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:windshield/routes/app_router.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import './overview_comp/inc_exp.dart';

class Overview extends StatelessWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    MyTheme.kToDark.shade300,
                  ]),
            ),
            height: 210,
          ),
          Container(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const IncExp(),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            AutoRouter.of(context).push(const StatementRoute());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            child: FaIcon(
                              FontAwesomeIcons.chartPie,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: MyTheme.kToDark[50],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'แผนงบการเงิน',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            child: FaIcon(
                              FontAwesomeIcons.balanceScale,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: MyTheme.kToDark[50],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'งบดุลการเงิน',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            child: FaIcon(
                              FontAwesomeIcons.solidFlag,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: MyTheme.kToDark[50],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'เป้าหมาย\nทางการเงิน',
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            child: FaIcon(
                              FontAwesomeIcons.percentage,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: MyTheme.kToDark[50],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'วางแผนจัดการ\nหนี้สิน',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
