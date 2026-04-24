import 'dart:io';

import 'package:flu_vcc_ads/flu_vcc_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/ad_item.dart';

class BasicWidget extends StatefulWidget {
  final AdItem item;

  const BasicWidget({super.key, required this.item});

  @override
  State<BasicWidget> createState() => _BasicWidgetState();
}

class _BasicWidgetState extends State<BasicWidget> {
  String get _tag => "basic_screen_${widget.item.type.name}_${widget.item.id}";

  late final VccAdControl _control;

  bool _isReady = false;
  String? _adTag, _requestId, _adId, _adType;
  double? _adHeightPx;

  @override
  void initState() {
    super.initState();
    _control = VccAdControl(tag: _tag);

    final id = widget.item.type.ids.first.toString();
    _control.addAdId(id, (event) {
      if (!mounted) return;
      setState(() {
        switch (event.type) {
          case AdEventType.ready:
            Logger.i("[$_tag] ready adId=${event.adId} adType=${event.adType}");
            if (event.adType.toLowerCase() == 'welcome') {
              _control.showWelcomeAd(event.requestId, event.adId);
            } else {
              _isReady = true;
              _adTag = event.tag;
              _requestId = event.requestId;
              _adId = event.adId;
              _adType = event.adType;
            }
          case AdEventType.size:
            Logger.i("[$_tag] size adId=${event.adId} height=${event.height}");
            if (event.height != null) _adHeightPx = event.height;
          case AdEventType.fail:
            Logger.w("[$_tag] fail adId=${event.adId} msg=${event.message}");
        }
      });
    } as AdCallback);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _control.requestAds("1");
    });
  }

  @override
  void dispose() {
    _control.dispose();
    super.dispose();
  }

  Widget _buildAdView() {
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final height = _adHeightPx != null ? _adHeightPx! / ratio : kVccIosBannerPlatformHeight;
    final adType = _adType ?? '';
    final isFullscreen =
        adType.toLowerCase() == 'non_popup' || adType.toLowerCase() == 'popup';

    if (Platform.isAndroid) {
      final androidView = AndroidView(
        viewType: NativeBridge.viewType,
        creationParams: {
          "tag": _adTag,
          "requestId": _requestId,
          "id": _adId,
          "adType": adType,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
      if (isFullscreen) {
        return SizedBox(width: double.infinity, height: double.infinity, child: androidView);
      }
      return SizedBox(width: double.infinity, height: height, child: androidView);
    }

    if (Platform.isIOS) {
      return SizedBox(
        width: double.infinity,
        height: kVccIosBannerPlatformHeight,
        child: UiKitView(
          viewType: NativeBridge.viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: {
            "tag": _adTag,
            "requestId": _requestId,
            "id": _adId,
          },
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) return const Center(child: CircularProgressIndicator());

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: _buildAdView(),
      ),
    );
  }
}
