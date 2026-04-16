import 'package:flu_vcc_ads/flu_vcc_ads.dart';
import 'package:flutter/material.dart';

import '../model/ad_item.dart';

class ListWidget extends StatefulWidget {
  final AdItem item;

  const ListWidget({super.key, required this.item});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  String get tag => "list_screen_${widget.item.id}";
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
    final List<int> ids = item.type.ids;
    const int adInterval = 10;

    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        if (index != 0 && index % adInterval == 0) {
          int adIndex = (index ~/ adInterval) - 1;
          String currentAdId;

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
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text("$index", style: const TextStyle(color: Colors.white)),
          ),
          title: Text("Bài viết nội dung số $index"),
          subtitle: const Text("Mô tả chi tiết bài viết..."),
          onTap: () {},
        );
      },
    );
  }
}
