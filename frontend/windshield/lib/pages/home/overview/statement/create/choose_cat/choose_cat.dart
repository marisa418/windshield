import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/category.dart';
import 'package:windshield/routes/app_router.dart';

class ChooseCat extends ConsumerWidget {
  const ChooseCat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statement = ref.watch(providerStatement);
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          // // const SizedBox(height: 30),
          // CategoryType('รายรับจากการทำงาน', income1, context),
          // // const SizedBox(height: 30),
          // CategoryType('รายรับจากสินทรัพย์', income2, context),
          // // const SizedBox(height: 30),
          // CategoryType('รายรับอื่นๆ', income3, context),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // ref.read(statementCreateProvider).setSelectedPage(0);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: 125,
                    child: Text(
                      'ย้อนกลับ',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2!.merge(
                            TextStyle(color: Colors.white),
                          ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final res = await ref.read(apiProvider).createStatement(
                        statement.startDate, statement.endDate);
                    if (res) {
                      AutoRouter.of(context).replace(StatementRoute());
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: 125,
                    child: Text(
                      'บันทึก',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2!.merge(
                            const TextStyle(color: Colors.white),
                          ),
                    ),
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

class CategoryType extends ConsumerWidget {
  const CategoryType(this.categoryType, this.category, this.context, {Key? key})
      : super(key: key);
  final List<Category> category;
  final String categoryType;
  final BuildContext context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      // color: Colors.green,
      width: MediaQuery.of(context).size.width,
      // alignment: Alignment.topLeft,
      child: Container(
        // color: Colors.green,
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              categoryType,
              style: Theme.of(context).textTheme.bodyText1!.merge(
                    const TextStyle(fontSize: 20),
                  ),
              // textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            Wrap(
              // crossAxisAlignment: WrapCrossAlignment.start,
              // alignment: WrapAlignment.start,
              spacing: 30,
              children: _generateCat(category),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _generateCat(List<Category> obj) {
    var list = obj.map<List<Widget>>(
      (data) {
        var widgetList = <Widget>[];
        widgetList.add(
          SizedBox(
            width: 60,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    height: 50,
                    width: 50,
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white.withOpacity(0.1),
                    shape: CircleBorder(),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
              ],
            ),
          ),
        );
        return widgetList;
      },
    ).toList();
    var output = list.expand((element) => element).toList();
    return output;
  }
}
