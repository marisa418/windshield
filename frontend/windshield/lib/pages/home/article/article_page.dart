import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';

// final provArticle =
//     ChangeNotifierProvider.autoDispose<ArticleProvider>((ref) => ArticleProvider());

final apiArticle = FutureProvider.autoDispose<void>((ref) async {
  final data = await ref.read(apiProvider).getAllArticles();
  return;
});

class ArticlePage extends ConsumerWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiArticle);
    return api.when(
      error: (error, stackTrace) => Text(stackTrace.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (_) => Column(
        children: [
          const Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Header(),
          ),
          Flexible(
            flex: 8,
            fit: FlexFit.tight,
            child: Container(
                // padding: const EdgeInsets.all(8),

                ),
          ),
        ],
      ),
    );
  }
}

class Header extends ConsumerWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 6,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ค้นหาบทความ',
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const HeaderChips(
                  text: 'หัวข้อ',
                  color: [Colors.grey, null],
                ),
                const SizedBox(width: 10),
                HeaderChips(
                  text: 'ความรู้พื้นฐาน',
                  color: MyTheme.incomeWorking,
                ),
                const SizedBox(width: 10),
                HeaderChips(
                  text: 'ข่าว/สัมภาษณ์',
                  color: MyTheme.savingAndInvest,
                ),
                const SizedBox(width: 10),
                HeaderChips(
                  text: 'ด้านการลงทุน',
                  color: MyTheme.assetLiquid,
                ),
                const SizedBox(width: 10),
                HeaderChips(
                  text: 'เกี่ยวกับหนี้สิน',
                  color: MyTheme.debtLong,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderChips extends StatelessWidget {
  const HeaderChips({
    required this.text,
    required this.color,
    Key? key,
  }) : super(key: key);

  final String text;
  final List<Color?> color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color[1]?.withOpacity(.2) ?? Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: color[0],
          ),
        ),
      ),
    );
  }
}
