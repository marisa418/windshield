import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

class IncExp extends ConsumerWidget {
  const IncExp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 270,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 55,
            child: Row(
              children: const [
                Income(),
                Expense(),
              ],
            ),
          ),
          const Flexible(
            flex: 45,
            child: Liquidity(),
          ),
        ],
      ),
    );
  }
}

class Income extends ConsumerWidget {
  const Income({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('รายรับเดือนนี้'),
            const Text(
              '+XXXX บ.',
              style: TextStyle(color: Color(0xff16D9AB), fontSize: 24),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff14b6da),
                        Color(0xff2ae194),
                      ]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircularPercentIndicator(
                      radius: 25,
                      progressColor: Colors.white,
                      percent: 1,
                      animation: true,
                      animationDuration: 2000,
                      lineWidth: 6.5,
                      center: Text('xx.x%',
                          style: TextStyle(color: Colors.white, fontSize: 11)),
                      backgroundColor: const Color(0x80ffffff),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'เป้ารายรับที่เหลือ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const Text(
                          'xxxxx บ.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Expense extends ConsumerWidget {
  const Expense({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('รายจ่ายเดือนนี้'),
            const Text(
              '-XXXX บ.',
              style: TextStyle(color: Color(0xffe3006d), fontSize: 24),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xffdf4833),
                        Color(0xffee3884),
                      ]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircularPercentIndicator(
                      radius: 25,
                      progressColor: Colors.white,
                      percent: 0.744,
                      animation: true,
                      animationDuration: 2000,
                      lineWidth: 6.5,
                      center: Text('xx.x%',
                          style: TextStyle(color: Colors.white, fontSize: 11)),
                      backgroundColor: const Color(0x80ffffff),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'เป้ารายจ่ายที่เหลือ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const Text(
                          'xxxxx บ.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Liquidity extends ConsumerWidget {
  const Liquidity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff5236ff),
                Color(0xff75a1e3),
              ]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularPercentIndicator(
              radius: 35,
              progressColor: Colors.white,
              percent: 0.725,
              animation: true,
              animationDuration: 2000,
              lineWidth: 10,
              center: Text('XX.X%', style: TextStyle(color: Colors.white)),
              backgroundColor: const Color(0x80ffffff),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'สภาพคล่องสุทธิปัจจุบัน',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const Text(
                  'xxxxx บ.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
                const Text(
                  'เหลือใช้วันนี้ xx.xx บ.',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
