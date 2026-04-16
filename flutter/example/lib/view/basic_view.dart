import 'package:flu_vcc_ads/flu_vcc_ads.dart';
import 'package:flutter/material.dart';

import '../model/ad_item.dart';

class BasicWidget extends StatefulWidget {
  final AdItem item;

  const BasicWidget({super.key, required this.item});

  @override
  State<BasicWidget> createState() => _BasicWidgetState();
}

class _BasicWidgetState extends State<BasicWidget> {
  String get tag => "basic_screen_${widget.item.type.name}_${widget.item.id}";
  String get requestId => widget.item.type.ids.first.toString();

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

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width,
            maxHeight: kVccIosBannerPlatformHeight,
          ),
          child: VccAdWidget(
            adId: id,
            tag: tag,
            control: control,
          ),
        ),
      ),
    );
  }
}
