import 'package:flutter/material.dart';

import '../model/ad_item.dart';
import '../view/basic_view.dart';
import '../view/list_view.dart';
import '../view/sticky_list_view.dart';

class DetailScreen extends StatelessWidget {
  final AdItem item;

  const DetailScreen({super.key, required this.item});

  static Future<void> push(
    BuildContext context, {
    required AdItem item,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final item = this.item;

    Widget body;
    switch (item.category) {
      case AdCategory.basic:
        body = BasicWidget(item: item);
        break;
      case AdCategory.mix:
        if (item.type == AdViewType.list) {
          body = ListWidget(item: item);
        } else if (item.type == AdViewType.stickyList) {
          body = StickyListWidget(item: item);
        } else {
          body = const Center(child: Text("Không hỗ trợ loại view này"));
        }
        break;
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cs.primary, cs.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.type.label,
              style: TextStyle(
                color: cs.onPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              item.category.name.toUpperCase(),
              style: TextStyle(
                color: cs.onPrimary.withOpacity(0.75),
                fontSize: 11,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
