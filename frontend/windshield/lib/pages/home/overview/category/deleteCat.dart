import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:windshield/main.dart';
import 'package:windshield/models/balance_sheet/balance_sheet.dart';
import 'package:windshield/models/daily_flow/flow.dart';
import 'package:windshield/pages/home/overview/category/category_page.dart';
import 'package:windshield/styles/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:badges/badges.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:flutter/cupertino.dart';

class DeleteCat extends ConsumerWidget {
  const DeleteCat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    

    return Expanded(
      child: DeleteForm(),
      );
  }
}

class DeleteForm extends ConsumerWidget {
  const DeleteForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    

    return Expanded(
      child: AddCatForm(),
      );
  }
}

class AddCatForm extends ConsumerWidget {
  const AddCatForm({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curCat = ref.watch(provCat.select((e) => e.currCat)); 
    return Container(
      color: Colors.white,
      
      child: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(curCat.name, style: MyTheme.whiteTextTheme.headline3),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 75, //height of button
                        width: 75, //width of button
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Icon(
                          HelperIcons.getIconData(curCat.icon),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                          ),
                        ]
                        
                      ),
                    ],
                  ),
                 
                  
                  //ลบออก
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final asset = await ref.read(apiProvider).deleteCategory(
                              
                              ref.read(provCat).id,
                              
                            );
                        if (asset) {
                          ref.read(provCat).setNeedFetchAPI();
                          AutoRouter.of(context).pop();
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      child: Text('ลบ', style: MyTheme.whiteTextTheme.headline3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
