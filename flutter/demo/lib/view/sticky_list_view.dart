import 'dart:io';

import 'package:flu_vcc_ads/flu_vcc_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/ad_item.dart';

class StickyListWidget extends StatefulWidget {
  final AdItem item;

  const StickyListWidget({super.key, required this.item});

  @override
  State<StickyListWidget> createState() => _StickyListWidgetState();
}

class _StickyListWidgetState extends State<StickyListWidget> {
  late final VccAdControl _control;
  String get _tag => "sticky_list_screen_${widget.item.id}";

  final Map<String, List<String>> _readyAds = {};
  final Map<String, double> _adHeights = {};

  @override
  void initState() {
    super.initState();
    _control = VccAdControl(tag: _tag);

    for (final id in widget.item.type.ids) {
      final adId = id.toString();
      _control.addAdId(adId, (event) {
        if (!mounted) return;
        setState(() {
          switch (event.type) {
            case AdEventType.ready:
              Logger.i("[$_tag] ready adId=${event.adId} adType=${event.adType}");
              if (event.adType.toLowerCase() == 'welcome') {
                _control.showWelcomeAd(event.requestId, event.adId);
              } else {
                _readyAds[event.adId] = [event.tag, event.requestId];
              }
            case AdEventType.size:
              Logger.i("[$_tag] size adId=${event.adId} height=${event.height}");
              if (event.height != null) _adHeights[event.adId] = event.height!;
            case AdEventType.fail:
              Logger.w("[$_tag] fail adId=${event.adId} msg=${event.message}");
          }
        });
      } as AdCallback);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _control.requestAds("1");
    });
  }

  @override
  void dispose() {
    _control.dispose();
    super.dispose();
  }

  Widget _buildAdView(String adId, String slotTag) {
    final ready = _readyAds[adId];
    if (ready == null) return const SizedBox.shrink();
    final adType = _control.getAdType(adId);
    if (Platform.isAndroid) {
      final isFullscreen = adType.toLowerCase() == 'non_popup' ||
          adType.toLowerCase() == 'popup';
      final view = AndroidView(
        viewType: NativeBridge.viewType,
        creationParams: {
          "tag": ready[0],
          "requestId": ready[1],
          "id": adId,
          "adType": adType,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
      if (isFullscreen) {
        return SizedBox(
            width: double.infinity, height: double.infinity, child: view);
      }
      return view;
    }
    if (Platform.isIOS) {
      return SizedBox(
        width: double.infinity,
        height: kVccIosBannerPlatformHeight,
        child: UiKitView(
          viewType: NativeBridge.viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: {
            "tag": ready[0],
            "requestId": ready[1],
            "id": adId,
          },
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final List<int> ids = widget.item.type.ids;
    const int adInterval = 10;
    final String stickyAdId = ids.first.toString();
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final stickyHeightPx = _adHeights[stickyAdId];
    final stickyHeight = _readyAds.containsKey(stickyAdId)
        ? (stickyHeightPx != null ? stickyHeightPx / ratio : kVccIosBannerPlatformHeight)
        : 0.0;

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyAdDelegate(
            minHeight: stickyHeight,
            maxHeight: stickyHeight,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: _buildAdView(stickyAdId, "$_tag-sticky"),
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index != 0 && index % adInterval == 0) {
                final int adIndex = index ~/ adInterval;
                final String adId = adIndex < ids.length
                    ? ids[adIndex].toString()
                    : "0";

                if (!_readyAds.containsKey(adId)) return const SizedBox.shrink();

                final inlineHeightPx = _adHeights[adId];
                final inlineHeight = inlineHeightPx != null ? inlineHeightPx / ratio : kVccIosBannerPlatformHeight;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: inlineHeight,  // null → wrap_content
                      width: double.infinity,
                      child: _buildAdView(adId, "$_tag-$index"),
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
