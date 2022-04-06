import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windshield/main.dart';
import 'package:windshield/pages/home/overview/daily_flow/speech/speech_to_text.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';

class IncWorkingList extends ConsumerWidget {
  const IncWorkingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorkingList = ref.watch(provDFlow.select((e) => e.incWorkingList));
    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: incWorkingList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
      ),
      itemBuilder: (context, i) {
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(provSpeech).setCat(
                              incWorkingList[i].id,
                              incWorkingList[i].icon,
                              MyTheme.incomeWorking[0],
                            );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: MyTheme.incomeWorking[0],
                        textStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.all(10),
                        shape: const CircleBorder(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            HelperIcons.getIconData(
                              incWorkingList[i].icon,
                            ),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
              child: AutoSizeText(
                incWorkingList[i].name,
                style: MyTheme.textTheme.bodyText2,
                minFontSize: 8,
                maxLines: 2,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}

class IncAssetList extends ConsumerWidget {
  const IncAssetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incAssetList = ref.watch(provDFlow.select((e) => e.incAssetList));
    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: incAssetList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
      ),
      itemBuilder: (_, i) {
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(provSpeech).setCat(
                              incAssetList[i].id,
                              incAssetList[i].icon,
                              MyTheme.incomeAsset[0],
                            );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: MyTheme.incomeAsset[0],
                        textStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.all(10),
                        shape: const CircleBorder(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            HelperIcons.getIconData(
                              incAssetList[i].icon,
                            ),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
              child: AutoSizeText(
                incAssetList[i].name,
                style: MyTheme.textTheme.bodyText2,
                minFontSize: 8,
                maxLines: 2,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}

class IncOtherList extends ConsumerWidget {
  const IncOtherList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incOtherList = ref.watch(provDFlow.select((e) => e.incOtherList));
    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: incOtherList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
      ),
      itemBuilder: (_, i) {
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(provSpeech).setCat(
                              incOtherList[i].id,
                              incOtherList[i].icon,
                              MyTheme.incomeOther[0],
                            );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: MyTheme.incomeOther[0],
                        textStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.all(10),
                        shape: const CircleBorder(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            HelperIcons.getIconData(
                              incOtherList[i].icon,
                            ),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
              child: AutoSizeText(
                incOtherList[i].name,
                style: MyTheme.textTheme.bodyText2,
                minFontSize: 8,
                maxLines: 2,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ExpInconList extends ConsumerWidget {
  const ExpInconList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expInconList = ref.watch(provDFlow.select((e) => e.expInconList));
    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: expInconList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
      ),
      itemBuilder: (_, i) {
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(provSpeech).setCat(
                              expInconList[i].id,
                              expInconList[i].icon,
                              MyTheme.expenseInconsist[0],
                            );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: MyTheme.expenseInconsist[0],
                        textStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.all(10),
                        shape: const CircleBorder(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            HelperIcons.getIconData(
                              expInconList[i].icon,
                            ),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
              child: AutoSizeText(
                expInconList[i].name,
                style: MyTheme.textTheme.bodyText2,
                minFontSize: 8,
                maxLines: 2,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ExpConList extends ConsumerWidget {
  const ExpConList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expConList = ref.watch(provDFlow.select((e) => e.expConList));
    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: expConList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
      ),
      itemBuilder: (_, i) {
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(provSpeech).setCat(
                              expConList[i].id,
                              expConList[i].icon,
                              MyTheme.expenseConsist[0],
                            );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: MyTheme.expenseConsist[0],
                        textStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.all(10),
                        shape: const CircleBorder(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            HelperIcons.getIconData(
                              expConList[i].icon,
                            ),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
              child: AutoSizeText(
                expConList[i].name,
                style: MyTheme.textTheme.bodyText2,
                minFontSize: 8,
                maxLines: 2,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}

class SavInvList extends ConsumerWidget {
  const SavInvList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savAndInvList = ref.watch(provDFlow.select((e) => e.savAndInvList));
    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: savAndInvList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
      ),
      itemBuilder: (_, i) {
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(provSpeech).setCat(
                              savAndInvList[i].id,
                              savAndInvList[i].icon,
                              MyTheme.savingAndInvest[0],
                            );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: MyTheme.savingAndInvest[0],
                        textStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.all(10),
                        shape: const CircleBorder(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            HelperIcons.getIconData(
                              savAndInvList[i].icon,
                            ),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
              child: AutoSizeText(
                savAndInvList[i].name,
                style: MyTheme.textTheme.bodyText2,
                minFontSize: 8,
                maxLines: 2,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
