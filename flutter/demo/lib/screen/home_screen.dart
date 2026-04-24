import 'package:flu_vcc_ads_example/model/ad_item.dart';
import 'package:flu_vcc_ads_example/view/common_view.dart';
import 'package:flu_vcc_ads_example/view/request_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdListBloc()..add(LoadAdList()),
      child: const _HomeTabView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab shell
// ─────────────────────────────────────────────────────────────────────────────
class _HomeTabView extends StatefulWidget {
  const _HomeTabView();

  @override
  State<_HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<_HomeTabView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cs.primary, cs.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            const _VccLogo(),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VCCorp Ads SDK',
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  'Demo & Playground',
                  style: TextStyle(
                    color: cs.onPrimary.withOpacity(0.75),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: cs.onPrimary,
          indicatorWeight: 3,
          labelColor: cs.onPrimary,
          unselectedLabelColor: cs.onPrimary.withOpacity(0.6),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.view_list_rounded), text: 'Demo'),
            Tab(icon: Icon(Icons.tune_rounded), text: 'Manual Request'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DemoListTab(),
          const RequestAdWidget(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small logo widget
// ─────────────────────────────────────────────────────────────────────────────
class _VccLogo extends StatelessWidget {
  const _VccLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: const Text(
        'V',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Demo list tab
// ─────────────────────────────────────────────────────────────────────────────
class _DemoListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdListBloc, AdListState>(
      builder: (context, state) {
        if (state is AdListLoaded) {
          return _buildList(context, state.items);
        }
        return commonProgress();
      },
    );
  }

  Widget _buildList(BuildContext context, List<AdItem> items) {
    final grouped = _groupByCategory(items);
    return CustomScrollView(
      slivers: grouped.entries.map((entry) {
        return SliverMainAxisGroup(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _HeaderDelegate(entry.key),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = entry.value[index];
                    return _AdItemCard(
                      item: item,
                      index: index,
                      onTap: () => DetailScreen.push(context, item: item),
                    );
                  },
                  childCount: entry.value.length,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Map<AdCategory, List<AdItem>> _groupByCategory(List<AdItem> items) {
    final map = <AdCategory, List<AdItem>>{};
    for (var item in items) {
      map.putIfAbsent(item.category, () => []).add(item);
    }
    return map;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ad item card
// ─────────────────────────────────────────────────────────────────────────────
class _AdItemCard extends StatefulWidget {
  final AdItem item;
  final int index;
  final VoidCallback onTap;

  const _AdItemCard({
    required this.item,
    required this.index,
    required this.onTap,
  });

  @override
  State<_AdItemCard> createState() => _AdItemCardState();
}

class _AdItemCardState extends State<_AdItemCard> {
  bool _pressed = false;

  IconData _iconFor(AdViewType type) {
    switch (type) {
      case AdViewType.banner:
        return Icons.view_headline_rounded;
      case AdViewType.popup:
        return Icons.open_in_new_rounded;
      case AdViewType.inPage:
        return Icons.web_rounded;
      case AdViewType.welcome:
        return Icons.waving_hand_rounded;
      case AdViewType.catfish:
        return Icons.vertical_align_bottom_rounded;
      case AdViewType.home:
        return Icons.home_rounded;
      case AdViewType.list:
        return Icons.list_alt_rounded;
      case AdViewType.stickyList:
        return Icons.push_pin_rounded;
    }
  }

  Color _accentFor(AdViewType type) {
    const palette = [
      Color(0xFF1565C0),
      Color(0xFF6A1B9A),
      Color(0xFF00695C),
      Color(0xFFE65100),
      Color(0xFF283593),
      Color(0xFF558B2F),
      Color(0xFF4527A0),
      Color(0xFF37474F),
    ];
    return palette[type.index % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final item = widget.item;
    final accent = _accentFor(item.type);
    final idLabel = item.type.ids.length == 1
        ? 'ID: ${item.type.ids.first}'
        : 'IDs: ${item.type.ids.join(', ')}';

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: cs.outlineVariant.withOpacity(0.4),
            ),
          ),
          child: Row(
            children: [
              // Colored left accent bar
              Container(
                width: 4,
                height: 72,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
              ),
              // Icon badge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(_iconFor(item.type), color: accent, size: 22),
                ),
              ),
              // Text content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.type.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        idLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Chevron
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: cs.onSurface.withOpacity(0.35),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  static const double _height = 44.0;
  final AdCategory category;

  _HeaderDelegate(this.category);

  String get _label => switch (category) {
        AdCategory.basic => '🎯  BASIC ADS',
        AdCategory.mix => '🧩  MIX ADS',
      };

  Color get _accent => switch (category) {
        AdCategory.basic => const Color(0xFF1565C0),
        AdCategory.mix => const Color(0xFF6A1B9A),
      };

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: _accent.withOpacity(0.15),
            width: 1.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _accent,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(covariant _HeaderDelegate old) =>
      old.category != category;
}
