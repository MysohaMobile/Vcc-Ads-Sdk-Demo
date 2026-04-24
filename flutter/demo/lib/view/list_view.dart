import 'dart:io';

import 'package:flu_vcc_ads/flu_vcc_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/ad_item.dart';

class ListWidget extends StatefulWidget {
  final AdItem item;

  const ListWidget({super.key, required this.item});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  late final VccAdControl _control;
  String get _tag => "list_screen_${widget.item.id}";

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

    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        if (index != 0 && index % adInterval == 0) {
          final int adIndex = (index ~/ adInterval) - 1;
          final String adId = adIndex < ids.length
              ? ids[adIndex].toString()
              : "0";

          if (!_readyAds.containsKey(adId)) return const SizedBox.shrink();

          final ratio = MediaQuery.devicePixelRatioOf(context);
          final heightPx = _adHeights[adId];
          final height = heightPx != null ? heightPx / ratio : kVccIosBannerPlatformHeight;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: height,
                width: double.infinity,
                child: _buildAdView(adId, "$_tag-$index"),
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
