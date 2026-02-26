// screens/user/auctions_screen.dart — live Firestore stream
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/user_theme.dart';
import '../../models/app_models.dart';
import '../../services/product_service.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import 'auction_detail_screen.dart';
import '../../../main.dart' show RoleGateway;

class AuctionsScreen extends StatefulWidget {
  const AuctionsScreen({super.key});

  @override
  State<AuctionsScreen> createState() => _AuctionsScreenState();
}

class _AuctionsScreenState extends State<AuctionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _productService = ProductService();
  final _authService    = AuthService();
  final _notifService   = NotificationService();
  int _navIndex = 0;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RoleGateway()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: UserTheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: UserTheme.primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.gavel_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('BidForge'),
          ],
        ),
        actions: [
          // Notification badge
          StreamBuilder<int>(
            stream: _notifService.watchUnreadCount(uid),
            builder: (_, snap) {
              final count = snap.data ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: UserTheme.errorRed,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('$count',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: _signOut,
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: UserTheme.primaryBlue,
          labelColor: UserTheme.primaryBlue,
          unselectedLabelColor: UserTheme.textMuted,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(text: 'Live'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Ended'),
          ],
        ),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productService.watchPublishedProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                  color: UserTheme.primaryBlue),
            );
          }

          final all = snapshot.data!;

          // Filter by search
          final filtered = _search.isEmpty
              ? all
              : all
                  .where((p) => p.title
                      .toLowerCase()
                      .contains(_search.toLowerCase()))
                  .toList();

          final live     = filtered.where((p) => p.status == BidStatus.live).toList();
          final upcoming = filtered.where((p) => p.status == BidStatus.upcoming).toList();
          final ended    = filtered.where((p) => p.status == BidStatus.ended).toList();

          return Column(
            children: [
              // Search bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      Responsive.isDesktop(context) ? 120 : 16,
                  vertical: 10,
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'Search items, brands, or eras...',
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: UserTheme.textMuted),
                    suffixIcon: _search.isNotEmpty
                        ? GestureDetector(
                            onTap: () =>
                                setState(() => _search = ''),
                            child: const Icon(Icons.close_rounded,
                                color: UserTheme.textMuted),
                          )
                        : null,
                  ),
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    _ProductList(products: live, label: 'Live'),
                    _ProductList(products: upcoming, label: 'Upcoming'),
                    _ProductList(products: ended, label: 'Ended'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// ── Product list ──────────────────────────────────────────────────────────────
class _ProductList extends StatelessWidget {
  final List<Product> products;
  final String label;

  const _ProductList({required this.products, required this.label});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 56, color: UserTheme.textMuted),
            const SizedBox(height: 12),
            Text('No $label auctions',
                style: UserTextStyles.h3),
            const SizedBox(height: 6),
            const Text('Check back soon!',
                style: UserTextStyles.label),
          ],
        ),
      );
    }

    final cols = Responsive.auctionGridCols(context);
    final hPad = Responsive.isDesktop(context) ? 120.0 : 16.0;

    if (cols == 1) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _ProductCard(product: products[i]),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) => _ProductCard(product: products[i]),
    );
  }
}

// ── Product card ──────────────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  Color get _statusColor {
    switch (product.status) {
      case BidStatus.live:     return UserTheme.successGreen;
      case BidStatus.upcoming: return UserTheme.warningGold;
      case BidStatus.ended:    return UserTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => AuctionDetailScreen(product: product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: UserTheme.divider),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / placeholder
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  color: const Color(0xFF1E293B),
                  child: product.imageUrl != null
                      ? Image.network(product.imageUrl!,
                          fit: BoxFit.cover)
                      : const Center(
                          child: Icon(Icons.inventory_2_outlined,
                              size: 56,
                              color: Colors.white38),
                        ),
                ),
                // Status badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statusColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.status.label.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                // Countdown for live
                if (product.status == BidStatus.live)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: _CountdownText(product: product),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: UserTextStyles.h3.copyWith(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text('Current Bid',
                              style: UserTextStyles.caption),
                          Text(
                            '\$${product.currentHighestBid.toStringAsFixed(2)}',
                            style: UserTextStyles.price
                                .copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                      // Winner badge
                      if (product.status == BidStatus.ended &&
                          product.winnerName != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: UserTheme.successGreen
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: UserTheme.successGreen
                                    .withOpacity(0.4)),
                          ),
                          child: Text(
                            '🏆 ${product.winnerName}',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: UserTheme.successGreen),
                          ),
                        ),
                    ],
                  ),

                  if (product.status == BidStatus.live) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  AuctionDetailScreen(
                                      product: product)),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 38),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10)),
                        ),
                        child: const Text('Place Bid',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Countdown that rebuilds every second ─────────────────────────────────────
class _CountdownText extends StatefulWidget {
  final Product product;
  const _CountdownText({required this.product});

  @override
  State<_CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<_CountdownText> {
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.product.remaining;
    _tick();
  }

  void _tick() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _remaining = widget.product.remaining;
        });
        if (_remaining > Duration.zero) _tick();
      }
    });
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _format(_remaining),
      style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700),
    );
  }
}

// ── Bottom nav ────────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: UserTheme.divider)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.gavel_rounded, label: 'Auctions',
                  index: 0, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.explore_outlined, label: 'Explore',
                  index: 1, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.history_rounded, label: 'My Bids',
                  index: 2, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.person_outline_rounded, label: 'Profile',
                  index: 3, current: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, current;
  final Function(int) onTap;

  const _NavItem({
    required this.icon, required this.label,
    required this.index, required this.current, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 22,
                color: active
                    ? UserTheme.primaryBlue
                    : UserTheme.textMuted),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: active
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: active
                        ? UserTheme.primaryBlue
                        : UserTheme.textMuted)),
          ],
        ),
      ),
    );
  }
}
