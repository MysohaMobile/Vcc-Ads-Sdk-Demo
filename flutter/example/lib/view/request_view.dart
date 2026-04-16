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
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _control?.dispose();
    super.dispose();
  }

  void _requestAd() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final adId = _controller.text.trim();

    // Dispose old control
    _control?.dispose();
    final newControl = VccAdControl(tag: _tag);
    _control = newControl;

    setState(() {
      _currentAdId = adId;
      _isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      newControl.requestAds("manual");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // ── Input area ──────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            border: Border(
              bottom: BorderSide(color: theme.dividerColor),
            ),
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Vui lòng nhập Ad Slot ID';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _requestAd(),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _requestAd,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    label: const Text('Request'),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Ad preview area ─────────────────────────────────────────
        Expanded(
          child: _buildAdArea(theme),
        ),
      ],
    );
  }

  Widget _buildAdArea(ThemeData theme) {
    if (_currentAdId == null || _control == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_search,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Nhập Ad Slot ID và nhấn Request\nđể xem quảng cáo.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
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
              Icon(Icons.info_outline,
                  size: 16, color: theme.colorScheme.outline),
              const SizedBox(width: 6),
              Text(
                'Ad Slot: $_currentAdId',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
            ],
          ),
        ),
        Expanded(
          child: VccAdWidget(
            key: ValueKey(_currentAdId),
            adId: _currentAdId!,
            tag: _tag,
            control: _control!,
          ),
        ),
      ],
    );
  }
}
