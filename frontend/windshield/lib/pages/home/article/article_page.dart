import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:windshield/main.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/providers/article_provider.dart';

final provArticle = ChangeNotifierProvider.autoDispose<ArticleProvider>(
    (ref) => ArticleProvider());

final apiArticle = FutureProvider.autoDispose<void>((ref) async {
  final page = ref.read(provArticle).page;
  final search = ref.read(provArticle).search;
  final ignoreList = ref.read(provArticle).areTopicsEnable;
  final sort = ref.read(provArticle).currSort;
  final isAsc = ref.read(provArticle).isAscend;
  final price = ref.read(provArticle).priceRange;
  final data = await ref
      .read(apiProvider)
      .getArticles(page, search, ignoreList, sort, isAsc, price);
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 6,
            child: Row(
              children: [
                Flexible(
                  flex: 8,
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'ค้นหาบทความ',
                        hintStyle: MyTheme.textTheme.bodyText1,
                        isCollapsed: true,
                        prefixIcon: const Icon(Icons.search),
                        fillColor: Colors.grey.withOpacity(.2),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      onSubmitted: (e) {
                        ref.read(provArticle).setSearch(e);
                        ref.refresh(apiArticle);
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      // showDialog(
                      //   useRootNavigator: false,
                      //   context: context,
                      //   builder: (_) => const FilterDialog(),
                      // );
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: MyTheme.primaryMajor,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.filter_alt_rounded,
                        color: MyTheme.primaryMajor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            child: SizedBox(
              height: 35,
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
          ),
        ],
      ),
    );
  }
}

class FilterDialog extends ConsumerWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final from = ref.watch(provArticle.select((e) => e.priceRange[0]));
    final to = ref.watch(provArticle.select((e) => e.priceRange[1]));
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    'เรียง',
                    style: MyTheme.textTheme.bodyText2,
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    style: MyTheme.textTheme.bodyText1!.merge(
                      const TextStyle(color: Colors.black),
                    ),
                    value: ref.watch(provArticle.select((e) => e.currSort)),
                    onChanged: (String? e) {
                      ref.read(provArticle).setCurrSort(e!);
                    },
                    items: ref
                        .watch(provArticle.select((e) => e.sortList))
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: ref.read(provArticle).returnString(value),
                        child: AutoSizeText(
                          value,
                          minFontSize: 0,
                          maxLines: 1,
                          style: MyTheme.textTheme.bodyText2,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    'จาก',
                    style: MyTheme.textTheme.bodyText2,
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    style: MyTheme.textTheme.bodyText1!.merge(
                      const TextStyle(color: Colors.black),
                    ),
                    value: ref.watch(provArticle.select((e) => e.isAscend)),
                    onChanged: (bool? e) {
                      ref.read(provArticle).setIsAscend(e!);
                    },
                    items: ['น้อยไปมาก', 'มากไปน้อย']
                        .map<DropdownMenuItem<bool>>((String value) {
                      return DropdownMenuItem<bool>(
                        value: value.contains('น้อยไปมาก') ? true : false,
                        child: AutoSizeText(
                          value,
                          minFontSize: 0,
                          maxLines: 1,
                          style: MyTheme.textTheme.bodyText2,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    'ช่วงราคา',
                    style: MyTheme.textTheme.bodyText2,
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextFormField(
                          onChanged: (e) => ref.read(provArticle).setPriceRange(
                                int.parse(e),
                                0,
                              ),
                          initialValue: from == 0 ? null : '$from',
                          keyboardType: TextInputType.number,
                          style: MyTheme.textTheme.bodyText2,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          'ถึง',
                          style: MyTheme.textTheme.bodyText2,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextFormField(
                          onChanged: (e) => ref.read(provArticle).setPriceRange(
                                int.parse(e),
                                1,
                              ),
                          initialValue: to == 0 ? null : '$to',
                          keyboardType: TextInputType.number,
                          style: MyTheme.textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    //   child: AlertDialog(
    //     content: SizedBox(
    //       width: double.maxFinite,
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           SizedBox(
    //             height: 60,
    //             child: Row(
    //               children: [
    //                 Flexible(
    //                   flex: 2,
    //                   fit: FlexFit.tight,
    //                   child: Text(
    //                     'เรียง',
    //                     style: MyTheme.textTheme.bodyText2,
    //                   ),
    //                 ),
    //                 Flexible(
    //                   flex: 8,
    //                   child: DropdownButtonFormField(
    //                     isExpanded: true,
    //                     style: MyTheme.textTheme.bodyText1!.merge(
    //                       const TextStyle(color: Colors.black),
    //                     ),
    //                     // value: ref.watch(provArticle.select((e) => e.currSort)),
    //                     onChanged: (String? e) {
    //                       ref.read(provArticle).setCurrSort(e!);
    //                     },
    //                     items: ref
    //                         .watch(provArticle.select((e) => e.sortList))
    //                         .map<DropdownMenuItem<String>>((String value) {
    //                       return DropdownMenuItem<String>(
    //                         value: ref.read(provArticle).returnString(value),
    //                         child: AutoSizeText(
    //                           value,
    //                           minFontSize: 0,
    //                           maxLines: 1,
    //                           style: MyTheme.textTheme.bodyText2,
    //                         ),
    //                       );
    //                     }).toList(),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           SizedBox(
    //             height: 60,
    //             child: Row(
    //               children: [
    //                 Flexible(
    //                   flex: 2,
    //                   fit: FlexFit.tight,
    //                   child: Text(
    //                     'จาก',
    //                     style: MyTheme.textTheme.bodyText2,
    //                   ),
    //                 ),
    //                 Flexible(
    //                   flex: 8,
    //                   child: DropdownButtonFormField(
    //                     isExpanded: true,
    //                     style: MyTheme.textTheme.bodyText1!.merge(
    //                       const TextStyle(color: Colors.black),
    //                     ),
    //                     // value: ref.watch(provArticle.select((e) => e.isAscend)),
    //                     onChanged: (bool? e) {
    //                       ref.read(provArticle).setIsAscend(e!);
    //                     },
    //                     items: ['น้อยไปมาก', 'มากไปน้อย']
    //                         .map<DropdownMenuItem<bool>>((String value) {
    //                       return DropdownMenuItem<bool>(
    //                         value: value.contains('น้อยไปมาก') ? true : false,
    //                         child: AutoSizeText(
    //                           value,
    //                           minFontSize: 0,
    //                           maxLines: 1,
    //                           style: MyTheme.textTheme.bodyText2,
    //                         ),
    //                       );
    //                     }).toList(),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           SizedBox(
    //             height: 60,
    //             child: Row(
    //               children: [
    //                 Flexible(
    //                   flex: 2,
    //                   fit: FlexFit.tight,
    //                   child: Text(
    //                     'ช่วงราคา',
    //                     style: MyTheme.textTheme.bodyText2,
    //                   ),
    //                 ),
    //                 Flexible(
    //                   flex: 8,
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                     children: [
    //                       Flexible(
    //                         flex: 2,
    //                         child: TextFormField(
    //                           onChanged: (e) =>
    //                               ref.read(provArticle).setPriceRange(
    //                                     int.parse(e),
    //                                     0,
    //                                   ),
    //                           initialValue: from == 0 ? null : '$from',
    //                           keyboardType: TextInputType.number,
    //                           style: MyTheme.textTheme.bodyText2,
    //                         ),
    //                       ),
    //                       Flexible(
    //                         flex: 2,
    //                         child: Text(
    //                           'ถึง',
    //                           style: MyTheme.textTheme.bodyText2,
    //                         ),
    //                       ),
    //                       Flexible(
    //                         flex: 2,
    //                         child: TextFormField(
    //                           onChanged: (e) =>
    //                               ref.read(provArticle).setPriceRange(
    //                                     int.parse(e),
    //                                     1,
    //                                   ),
    //                           initialValue: to == 0 ? null : '$to',
    //                           keyboardType: TextInputType.number,
    //                           style: MyTheme.textTheme.bodyText2,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () => AutoRouter.of(context).pop(),
    //         child: const Text('ยืนยัน'),
    //       ),
    //     ],
    //   ),
    // );
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
    if (articles.pages == 0) {
      return const Center(
        child: Text(
          'ไม่พบบทความ',
        ),
      );
    }
    return Column(
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 9,
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
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
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
    return GestureDetector(
      onTap: () {
        if (article.price > 0 && !article.isUnlock) {
          final userPoint = ref.read(apiProvider).user?.points;
          showDialog(
            context: context,
            useRootNavigator: false,
            builder: (_) => AlertDialog(
              title: const Text('ปลดล็อคบทความ'),
              content:
                  Text('ราคา: ${article.price}\nจำนวนแต้มที่มี: $userPoint'),
              actions: [
                TextButton(
                  child: const Text('ยกเลิก'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  onPressed: userPoint != null && userPoint >= article.price
                      ? () async {
                          final pass = await ref
                              .read(apiProvider)
                              .unlockArticle(article.id);
                          if (pass) {
                            ref.read(provArticle).setId(article.id);
                            Navigator.of(context).pop();
                            AutoRouter.of(context)
                                .push(const ArticleReadRoute());
                            ref.refresh(apiArticle);
                          }
                        }
                      : null,
                  child: const Text('ยืนยัน'),
                ),
              ],
            ),
          );
        } else {
          ref.read(provArticle).setId(article.id);
          AutoRouter.of(context).push(const ArticleReadRoute());
        }
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          top: i == 0 ? 20 : 0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
                    Wrap(
                      children: [
                        if (article.price > 0)
                          article.isUnlock
                              ? const Icon(Icons.lock_open_outlined)
                              : const Icon(Icons.lock_outline),
                        Text(
                          article.topic,
                          style: MyTheme.textTheme.bodyText1!.merge(
                            const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
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
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      article.img,
                      alignment: Alignment.center,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      errorBuilder: (context, exception, stackTrace) {
                        return Container();
                      },
                    ),
                  ),
                  if (article.price > 0)
                    Positioned(
                      bottom: 5,
                      right: 10,
                      child: Container(
                        // padding: const EdgeInsets.all(2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black,
                        ),
                        child: Text(
                          'Exclusive',
                          style: MyTheme.whiteTextTheme.bodyText2!.merge(
                            const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
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
