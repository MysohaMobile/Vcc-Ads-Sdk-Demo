import 'package:flu_vcc_ads/flu_vcc_ads.dart';
import 'package:flutter/material.dart';

import '../model/ad_item.dart';

class StickyListWidget extends StatefulWidget {
  final AdItem item;

  const StickyListWidget({super.key, required this.item});

  @override
  State<StickyListWidget> createState() => _StickyListWidgetState();
}

class _StickyListWidgetState extends State<StickyListWidget> {
  String get tag => "sticky_list_screen_${widget.item.id}";
  String requestId = "1";
  late final VccAdControl control;

  @override
  void initState() {
    super.initState();
    control = VccAdControl(tag: tag);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      control.requestAds(requestId);
    });
  }

  @override
  void dispose() {
    control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final id = item.type.ids.first.toString();

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyAdDelegate(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: VccAdWidget(
                adId: id,
                tag: "$tag-sticky",
                control: control,
              ),
            ),
            minHeight: 100.0,
            maxHeight: 100.0,
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              const int adInterval = 10;
              if (index != 0 && index % adInterval == 0) {
                int adIndex = index ~/ adInterval;
                String currentAdId;
                final List<int> ids = item.type.ids;

                if (adIndex < ids.length) {
                  currentAdId = ids[adIndex].toString();
                } else {
                  currentAdId = "0";
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: VccAdWidget(
                        adId: currentAdId,
                        tag: "$tag-$index",
                        control: control,
                      ),
                    ),
                    const Divider(height: 20, thickness: 1),
                  ],
                );
              }

              return ListTile(
                leading: CircleAvatar(child: Text("$index")),
                title: Text("Nội dung bài viết $index"),
                subtitle: const Text("Mô tả chi tiết nội dung..."),
              );
            },
            childCount: 100,
          ),
        ),
      ],
    );
  }
}

class _StickyAdDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _StickyAdDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _StickyAdDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
