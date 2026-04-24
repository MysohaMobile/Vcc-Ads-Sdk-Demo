import 'dart:io';

import 'package:flu_vcc_ads/flu_vcc_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RequestAdWidget extends StatefulWidget {
  const RequestAdWidget({super.key});

  @override
  State<RequestAdWidget> createState() => _RequestAdWidgetState();
}

class _RequestAdWidgetState extends State<RequestAdWidget> {
  static const _tag = "manual_request";
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  VccAdControl? _control;
  String? _currentAdId;

  bool _isReady = false;
  String? _adTag, _requestId, _adId, _adType;
  double? _adHeightPx;

  @override
  void dispose() {
    _controller.dispose();
    _control?.dispose();
    super.dispose();
  }

  void _requestAd() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final adId = _controller.text.trim();

    _control?.dispose();
    final newControl = VccAdControl(tag: _tag);
    _control = newControl;

    setState(() {
      _currentAdId = adId;
      _isReady = false;
      _adTag = null;
      _requestId = null;
      _adId = null;
      _adType = null;
      _adHeightPx = null;
    });

    newControl.addAdId(adId, (event) {
      if (!mounted) return;
      setState(() {
        switch (event.type) {
          case AdEventType.ready:
            Logger.i("[$_tag] ready adId=${event.adId} adType=${event.adType}");
            if (event.adType.toLowerCase() == 'welcome') {
              _control!.showWelcomeAd(event.requestId, event.adId);
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
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) newControl.requestAds("1");
    });
  }

  Widget _buildAdView() {
    final ratio = MediaQuery.devicePixelRatioOf(context);
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
      if (_adHeightPx != null) {
        return SizedBox(width: double.infinity, height: _adHeightPx! / ratio, child: androidView);
      }
      return SizedBox(width: double.infinity, child: androidView);
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
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Ad Slot ID',
                      hintText: 'Nhập ad slot ID...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.ads_click),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Vui lòng nhập Ad Slot ID' : null,
                    onFieldSubmitted: (_) => _requestAd(),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _requestAd,
                    icon: const Icon(Icons.send),
                    label: const Text('Request'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _buildAdArea(theme)),
      ],
    );
  }

  Widget _buildAdArea(ThemeData theme) {
    if (_currentAdId == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_search, size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Nhập Ad Slot ID và nhấn Request\nđể xem quảng cáo.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: theme.colorScheme.outline),
              const SizedBox(width: 6),
              Text(
                'Ad Slot: $_currentAdId',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
              ),
            ],
          ),
        ),
        if (!_isReady)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else
          Expanded(child: _buildAdView()),
      ],
    );
  }
}
