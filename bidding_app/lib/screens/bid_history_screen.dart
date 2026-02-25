import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../widgets/admin_shell.dart';
import '../utils/responsive.dart';

class BidHistoryScreen extends StatelessWidget {
  const BidHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive.value<double>(mobile: 16, tablet: 20, desktop: 28);

    return AdminShell(
      currentRoute: '/bid-history',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            context.isMobile
                ? _MobileHeader()
                : _DesktopHeader(),
            const SizedBox(height: 24),

            // Winner card
            _WinnerCard(),
            const SizedBox(height: 24),

            // All bids
            _BidListCard(),
          ],
        ),
      ),
    );
  }
}

class _MobileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text('Wireless Headphones',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              overflow: TextOverflow.ellipsis),
        ),
      ]),
      const SizedBox(height: 4),
      const Padding(
        padding: EdgeInsets.only(left: 36),
        child: Text('Auction ended 2 hours ago',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: const Text('🏆 Winner: User #1247',
            style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    ]);
  }
}

class _DesktopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      const SizedBox(width: 8),
      const Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Wireless Headphones – Bid History',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          Text('Auction ended 2 hours ago',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        ]),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: const Text('🏆 Winner: User #1247',
            style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    ]);
  }
}

class _WinnerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: const Color(0xFFBBF7D0)),
        boxShadow: AppTheme.cardShadow,
      ),
      child: context.isMobile
          ? _WinnerCardMobile()
          : _WinnerCardDesktop(),
    );
  }
}

class _WinnerCardMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 48, height: 48,
          decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle),
          child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 14),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Winning Bid', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          Text('\$285.00',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppTheme.success, height: 1.1)),
        ]),
      ]),
      const SizedBox(height: 14),
      const Text('John Doe (User #1247)',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      const Text('john@example.com',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.notifications_active_rounded, size: 16),
          label: const Text('Notify Winner'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.success,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ]);
  }
}

class _WinnerCardDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 60, height: 60,
        decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle),
        child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 32),
      ),
      const SizedBox(width: 20),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Winning Bid', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        Text('\$285.00',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppTheme.success, height: 1.1)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const Text('Winner', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        const Text('John Doe (User #1247)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 4),
        const Text('john@example.com',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.notifications_active_rounded, size: 16),
          label: const Text('Notify Winner'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.success,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
          ),
        ),
      ]),
    ]);
  }
}

class _BidListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: context.isMobile
                ? const Text('All Bids (24 total)',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))
                : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('All Bids (24 total)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download_outlined, size: 16),
                      label: const Text('Export CSV'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        textStyle: const TextStyle(fontSize: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
                      ),
                    ),
                  ]),
          ),
          const Divider(color: AppTheme.cardBorder, height: 20),
          ...sampleBids.map((bid) => _BidRow(bid: bid)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.expand_more_rounded),
                label: const Text('Load 19 more bids'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BidRow extends StatelessWidget {
  final BidEntry bid;
  const _BidRow({required this.bid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: bid.isWinner ? const Color(0xFFF0FDF4) : AppTheme.surface,
        border: const Border(bottom: BorderSide(color: AppTheme.cardBorder)),
      ),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: bid.isWinner ? AppTheme.success : const Color(0xFF9CA3AF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('${bid.rank}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(bid.bidderName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textPrimary)),
              if (bid.isWinner) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Winner',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF166534))),
                ),
              ],
            ]),
            Text(bid.timeAgo, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ]),
        ),
        Text('\$${bid.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: context.isMobile ? 15 : 18,
              fontWeight: FontWeight.w700,
              color: bid.isWinner ? AppTheme.success : AppTheme.textPrimary,
            )),
      ]),
    );
  }
}
