import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/providers/article_provider.dart';

final provArticle = ChangeNotifierProvider.autoDispose<ArticleProvider>(
    (ref) => ArticleProvider());

final apiArticle = FutureProvider.autoDispose<void>((ref) async {
  final page = ref.read(provArticle).page;
  final data = await ref.read(apiProvider).getArticles(page);
  ref.read(provArticle).setArticles(data);
});

class ArticlePage extends ConsumerWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiArticle);
    ref.watch(provArticle);

    return Column(
      children: [
        const Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Header(),
        ),
        Flexible(
          flex: 8,
          fit: FlexFit.tight,
          child: api.when(
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (_) => const Body(),
          ),
        ),
      ],
    );
  }
}

class Header extends ConsumerWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final common = ref.watch(provArticle.select((e) => e.areTopicsEnable[0]));
    final news = ref.watch(provArticle.select((e) => e.areTopicsEnable[1]));
    final inv = ref.watch(provArticle.select((e) => e.areTopicsEnable[2]));
    final deb = ref.watch(provArticle.select((e) => e.areTopicsEnable[3]));

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
          const Flexible(
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
                  isSmall: false,
                  color: [Colors.grey, null],
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    ref.read(provArticle).setAreTopicsEnable(0, !common);
                    ref.refresh(apiArticle);
                  },
                  child: HeaderChips(
                    text: 'ความรู้พื้นฐาน',
                    isSmall: false,
                    color: common
                        ? MyTheme.incomeWorking
                        : [
                            Colors.grey,
                            Colors.grey.withOpacity(.3),
                          ],
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    ref.read(provArticle).setAreTopicsEnable(1, !news);
                    ref.refresh(apiArticle);
                  },
                  child: HeaderChips(
                    text: 'ข่าว/สัมภาษณ์',
                    isSmall: false,
                    color: news
                        ? MyTheme.savingAndInvest
                        : [
                            Colors.grey,
                            Colors.grey.withOpacity(.3),
                          ],
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    ref.read(provArticle).setAreTopicsEnable(2, !inv);
                    ref.refresh(apiArticle);
                  },
                  child: HeaderChips(
                    text: 'ด้านการลงทุน',
                    isSmall: false,
                    color: inv
                        ? MyTheme.assetLiquid
                        : [
                            Colors.grey,
                            Colors.grey.withOpacity(.3),
                          ],
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    ref.read(provArticle).setAreTopicsEnable(3, !deb);
                    ref.refresh(apiArticle);
                  },
                  child: HeaderChips(
                    text: 'เกี่ยวกับหนี้สิน',
                    isSmall: false,
                    color: deb
                        ? MyTheme.debtLong
                        : [
                            Colors.grey,
                            Colors.grey.withOpacity(.3),
                          ],
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

class HeaderChips extends StatelessWidget {
  const HeaderChips({
    required this.text,
    required this.color,
    required this.isSmall,
    Key? key,
  }) : super(key: key);

  final String text;
  final List<Color?> color;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSmall ? 20 : 50,
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 5 : 10),
      decoration: BoxDecoration(
        color: color[1]?.withOpacity(.2) ?? Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: color[0],
            fontSize: isSmall ? 8 : null,
          ),
        ),
      ),
    );
  }
}

class Body extends ConsumerWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(provArticle).articles;
    final page = ref.watch(provArticle).page;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: articles.articles.length,
              separatorBuilder: (_, i) => const SizedBox(
                height: 25,
              ),
              itemBuilder: (_, i) => ArticleItem(
                i: i,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (page == 1) return;
                    ref.read(provArticle).setPage(page - 1);
                    ref.refresh(apiArticle);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color:
                        page == 1 ? Colors.grey.withOpacity(.4) : Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  page.toString(),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    if (articles.pages == page) return;
                    ref.read(provArticle).setPage(page + 1);
                    ref.refresh(apiArticle);
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: articles.pages == page
                        ? Colors.grey.withOpacity(.4)
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ArticleItem extends ConsumerWidget {
  const ArticleItem({required this.i, Key? key}) : super(key: key);

  final int i;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final article =
        ref.watch(provArticle.select((e) => e.articles.articles[i]));
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'อัปโหลดเมื่อ ${DateFormat('d MMM y').format(article.uploadDate)}',
                    style: MyTheme.textTheme.bodyText2!.merge(
                      const TextStyle(
                        fontSize: 8,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    article.topic,
                    style: MyTheme.textTheme.bodyText1!.merge(
                      const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: article.subject.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, i) => const SizedBox(width: 2),
                      itemBuilder: (_, i) => HeaderChips(
                        text: article.subject[i].name,
                        color: getColor(article.subject[i].name),
                        isSmall: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Image.network(
                article.img,
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> getColor(String name) {
    if (name == 'พื้นฐาน') return MyTheme.incomeWorking;
    if (name == 'ข่าว/บทสัมภาษณ์') return MyTheme.savingAndInvest;
    if (name == 'การลงทุน') return MyTheme.assetLiquid;
    return MyTheme.debtLong;
  }
}
