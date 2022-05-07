import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import 'article_page.dart';

final apiArticleRead = FutureProvider.autoDispose<void>((ref) async {
  final id = ref.read(provArticle).id;
  final data = await ref.read(apiProvider).readArticle(id);
  ref.read(provArticle).setReadArticle(data);
});

class ArticleReadPage extends ConsumerWidget {
  const ArticleReadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final html = ref.watch(provArticle).articleRead.body;
    final api = ref.watch(apiArticleRead);
    return api.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (_) => SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const Header(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(
                      data: html,
                      style: {
                        'h4': Style(fontSize: FontSize.rem(2)),
                        'p': Style(fontSize: FontSize.rem(1.3)),
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends ConsumerStatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header> {
  bool like = false;

  @override
  void initState() {
    like = ref.read(provArticle).articleRead.like;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final article = ref.watch(provArticle.select((e) => e.articleRead));
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: MyTheme.majorBackground,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'อัปโหลดเมื่อ ${DateFormat('d MMM y').format(article.uploadDate)}',
                style: MyTheme.whiteTextTheme.bodyText1!.merge(
                  TextStyle(
                    color: Colors.white.withOpacity(.5),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    like = !like;
                  });
                  await ref.read(apiProvider).likeArticle(article.id);
                },
                child: like
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 30,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Colors.white.withOpacity(.5),
                        size: 30,
                      ),
              ),
            ],
          ),
          AutoSizeText(
            article.topic,
            style: MyTheme.whiteTextTheme.headline2,
            maxLines: 3,
            minFontSize: 0,
          ),
          SizedBox(
            height: 20,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: article.subject.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, i) => const SizedBox(width: 5),
              itemBuilder: (_, i) => HeaderChips(
                text: article.subject[i].name,
                color: [
                  Colors.white,
                  Colors.white.withOpacity(.4),
                ],
                isSmall: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
