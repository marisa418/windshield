import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:windshield/styles/theme.dart';

class StatTab extends ConsumerWidget {
  const StatTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'เกณฑ์การตัดสิน',
              style: MyTheme.textTheme.headline4!.merge(
                const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: MyTheme.positiveMajor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const Text('อยู่ในเกณฑ์ที่ ดี'),
                    ],
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: MyTheme.assetPersonal[0],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const Text('อยู่ในเกณฑ์ที่ ปานกลาง'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: MyTheme.expenseConsist[0],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const Text('อยู่ในเกณฑ์ที่ พอใช้'),
                    ],
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: MyTheme.negativeMajor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const Text('อยู่ในเกณฑ์ที่ แย่'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'ความมั่งคั่งในปัจจุบัน',
              style: MyTheme.textTheme.headline4!.merge(
                const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: MyTheme.positiveMajor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.commentDollar,
                          size: 50,
                          color: Colors.white,
                        ),
                        const Text(
                          'ความมั่งคั่งสุทธิ',
                          style: TextStyle(color: Colors.white),
                        ),
                        AutoSizeText(
                          'X,XXX บ.',
                          style: MyTheme.whiteTextTheme.headline3,
                          minFontSize: 0,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: MyTheme.expenseConsist[0],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.moneyBillWave,
                          size: 50,
                          color: Colors.white,
                        ),
                        const Text(
                          'กระเเสเงินสดสุทธิ',
                          style: TextStyle(color: Colors.white),
                        ),
                        AutoSizeText(
                          'X,XXX บ.',
                          style: MyTheme.whiteTextTheme.headline3,
                          minFontSize: 0,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: MyTheme.assetPersonal[0],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.balanceScale,
                          size: 40,
                          color: Colors.white,
                        ),
                        const Text(
                          'อัตราส่วนความมั่งคั่ง',
                          style: TextStyle(color: Colors.white),
                        ),
                        AutoSizeText(
                          'X,XXX บ.',
                          style: MyTheme.whiteTextTheme.headline3,
                          minFontSize: 0,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: MyTheme.negativeMajor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.dizzy,
                          size: 40,
                          color: Colors.white,
                        ),
                        const Text(
                          'อัตราส่วนความอยู่รอด',
                          style: TextStyle(color: Colors.white),
                        ),
                        AutoSizeText(
                          'X,XXX บ.',
                          style: MyTheme.whiteTextTheme.headline3,
                          minFontSize: 0,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'สภาพคล่องเเละ\nความสามารถในการชำระหนี้',
              style: MyTheme.textTheme.headline4!.merge(
                const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: MyTheme.positiveMajor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.coins,
                          size: 50,
                          color: Colors.white,
                        ),
                        const Text(
                          'อัตราส่วน\nสภาพคล่องพื้นฐาน',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        AutoSizeText(
                          'X,XXX บ.',
                          style: MyTheme.whiteTextTheme.headline3,
                          minFontSize: 0,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: MyTheme.expenseConsist[0],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.handHoldingUsd,
                          size: 50,
                          color: Colors.white,
                        ),
                        const Text(
                          'อัตราส่วนการชำระ\nหนี้สินจากรายได้',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        AutoSizeText(
                          'X,XXX บ.',
                          style: MyTheme.whiteTextTheme.headline3,
                          minFontSize: 0,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'โอกาสในการสร้างความมั่งคั่ง',
              style: MyTheme.textTheme.headline4!.merge(
                const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: MyTheme.assetPersonal[0],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.piggyBank,
                          size: 40,
                          color: Colors.white,
                        ),
                        const Text(
                          'อัตราส่วนการออม',
                          style: TextStyle(color: Colors.white),
                        ),
                        AutoSizeText(
                          'X,XXX บ.',
                          style: MyTheme.whiteTextTheme.headline3,
                          minFontSize: 0,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: MyTheme.negativeMajor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.chartLine,
                          size: 40,
                          color: Colors.white,
                        ),
                        const Text(
                          'อัตราส่วนการลงทุน',
                          style: TextStyle(color: Colors.white),
                        ),
                        AutoSizeText(
                          'X,XXX บ.',
                          style: MyTheme.whiteTextTheme.headline3,
                          minFontSize: 0,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
