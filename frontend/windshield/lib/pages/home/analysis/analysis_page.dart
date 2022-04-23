import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:windshield/styles/theme.dart';

class Analysis extends ConsumerStatefulWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalysisState();
}

class _AnalysisState extends ConsumerState<Analysis>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        TabBar(
          labelColor: Colors.black,
          controller: _tabController,
          tabs: [
            Tab(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    FontAwesomeIcons.exchangeAlt,
                    color: Colors.black,
                  ),
                  AutoSizeText(
                    'รายรับ-รายจ่าย',
                    maxLines: 1,
                    minFontSize: 0,
                    maxFontSize: 10,
                    style: MyTheme.textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            Tab(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    FontAwesomeIcons.chartPie,
                    color: Colors.black,
                  ),
                  AutoSizeText(
                    'งบการเงิน',
                    maxLines: 1,
                    minFontSize: 0,
                    maxFontSize: 10,
                    style: MyTheme.textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            Tab(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    FontAwesomeIcons.chartLine,
                    color: Colors.black,
                  ),
                  AutoSizeText(
                    'สินทรัพย์-หนี้สิน',
                    maxLines: 1,
                    minFontSize: 0,
                    maxFontSize: 10,
                    style: MyTheme.textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            Tab(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    FontAwesomeIcons.calculator,
                    color: Colors.black,
                  ),
                  AutoSizeText(
                    'สถิติทั่วไป',
                    maxLines: 1,
                    minFontSize: 0,
                    maxFontSize: 10,
                    style: MyTheme.textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const <Widget>[
              Center(
                child: Text("Fuck"),
              ),
              Center(
                child: Text("my"),
              ),
              Center(
                child: Text("life"),
              ),
              Center(
                child: Text("."),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
