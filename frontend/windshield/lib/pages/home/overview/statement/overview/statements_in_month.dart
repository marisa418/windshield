import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/statement.dart';

class StatementsInMonth extends ConsumerWidget {
  const StatementsInMonth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statement = ref.watch(providerStatement);
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: _generate(statement.statementsInMonth, context),
      ),
    );
  }

  List<Widget> _generate(List<Statement> obj, BuildContext context) {
    var list = obj.map<List<Widget>>(
      (data) {
        var widgetList = <Widget>[];
        widgetList.add(
          SizedBox(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  // margin: const EdgeInsets.all(10),
                  // width: MediaQuery.of(context).size.width,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.red,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: data.name == ''
                        ? Center(
                            child: Text(
                              'เพิ่มแผนการเงินใหม่',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          )
                        : Center(
                            child: Text(
                                '${data.name}\n${data.id}\n${data.start}\n${data.end}',
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                  ),
                )
              ],
            ),
          ),
        );
        return widgetList;
      },
    ).toList();
    var flat = list.expand((element) => element).toList();
    return flat;
  }
}
