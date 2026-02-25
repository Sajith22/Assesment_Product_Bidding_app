import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../widgets/admin_shell.dart';
import '../widgets/common_widgets.dart';
import '../utils/responsive.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _filter = 'All';

  List<Product> get _filteredProducts {
    if (_filter == 'All') return sampleProducts;
    final statusMap = {
      'Upcoming': AuctionStatus.upcoming,
      'Live':     AuctionStatus.live,
      'Ended':    AuctionStatus.ended,
    };
    return sampleProducts.where((p) => p.status == statusMap[_filter]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      currentRoute: '/dashboard',
      child: Column(
        children: [
          _DashboardHeader(onAddProduct: () => Navigator.pushNamed(context, '/add-product')),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.responsive.value(mobile: 16, tablet: 20, desktop: 28)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatsGrid(),
                  const SizedBox(height: 24),
                  _ProductTableCard(
                    filter: _filter,
                    products: _filteredProducts,
                    onFilterChanged: (v) => setState(() => _filter = v),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────
class _DashboardHeader extends StatelessWidget {
  final VoidCallback onAddProduct;
  const _DashboardHeader({required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: isMobile ? 16 : 20,
      ),
      child: isMobile
          // Mobile: stack vertically
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Product Dashboard',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('Manage bidding products',
                  style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 13)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: _AddButton(onTap: onAddProduct),
              ),
            ])
          // Tablet / Desktop: row
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Product Dashboard',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  SizedBox(height: 2),
                  Text('Manage bidding products and view analytics',
                      style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 13)),
                ]),
                _AddButton(onTap: onAddProduct),
              ],
            ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Add New Product'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Stats grid – 4 cols desktop, 2 cols tablet/mobile
// ─────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final crossAxisCount = context.isDesktop ? 4 : 2;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: context.isMobile ? 1.6 : 1.8,
      children: const [
        StatCard(label: 'Total Products', value: '24',    subtitle: '↑ 12% from last month'),
        StatCard(label: 'Live Auctions',  value: '8',     subtitle: 'Active bidding now',   valueColor: AppTheme.warning),
        StatCard(label: 'Total Bids',     value: '342',   subtitle: '↑ 28% increase',       valueColor: AppTheme.primary),
        StatCard(label: 'Revenue',        value: '\$45.2K', subtitle: '↑ 18% growth',       valueColor: AppTheme.success),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Product table card
// ─────────────────────────────────────────────
class _ProductTableCard extends StatelessWidget {
  final String filter;
  final List<Product> products;
  final ValueChanged<String> onFilterChanged;

  const _ProductTableCard({
    required this.filter,
    required this.products,
    required this.onFilterChanged,
  });

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
                // Mobile: stack title + filters
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Product List',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    const SizedBox(height: 10),
                    _FilterTabs(selected: filter, onChanged: onFilterChanged),
                  ])
                // Tablet/Desktop: row
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Product List',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      _FilterTabs(selected: filter, onChanged: onFilterChanged),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          // Mobile shows cards, Tablet/Desktop shows table
          context.isMobile
              ? _ProductCardList(products: products)
              : _ProductTable(products: products),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _FilterTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: ['All', 'Upcoming', 'Live', 'Ended'].map((label) {
        final isActive = selected == label;
        return InkWell(
          onTap: () => onChanged(label),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primary : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : AppTheme.textSecondary,
                )),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// MOBILE: Product cards (no horizontal scroll)
// ─────────────────────────────────────────────
class _ProductCardList extends StatelessWidget {
  final List<Product> products;
  const _ProductCardList({required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: products.map((p) => _ProductMobileCard(product: p)).toList(),
    );
  }
}

class _ProductMobileCard extends StatelessWidget {
  final Product product;
  const _ProductMobileCard({required this.product});

  @override
  Widget build(BuildContext context) {
    StatusBadge badge;
    switch (product.status) {
      case AuctionStatus.live:     badge = StatusBadge.live(); break;
      case AuctionStatus.upcoming: badge = StatusBadge.upcoming(); break;
      case AuctionStatus.ended:    badge = StatusBadge.ended(); break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.cardBorder)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(product.imageUrl, width: 52, height: 52, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 52, height: 52,
                    color: AppTheme.background,
                    child: const Icon(Icons.image, color: AppTheme.textMuted))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textPrimary)),
              const SizedBox(height: 2),
              Text(product.category,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              const SizedBox(height: 6),
              Row(children: [
                badge,
                const SizedBox(width: 8),
                Text(
                  product.currentBid != null
                      ? '\$${product.currentBid!.toStringAsFixed(0)}'
                      : '\$${product.startPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: product.currentBid != null ? AppTheme.success : AppTheme.textSecondary,
                  ),
                ),
              ]),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${product.bidCount} bids',
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 4),
            Text(product.endTime,
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/bid-history'),
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
              child: const Text('View', style: TextStyle(fontSize: 12)),
            ),
          ]),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TABLET / DESKTOP: DataTable
// ─────────────────────────────────────────────
class _ProductTable extends StatelessWidget {
  final List<Product> products;
  const _ProductTable({required this.products});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
        dividerThickness: 1,
        columns: const [
          DataColumn(label: Text('Product',     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('Status',      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('Start Price', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('Current Bid', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('Bids',        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('End Time',    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('Actions',     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
        ],
        rows: products.map((p) => _buildRow(context, p)).toList(),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, Product p) {
    StatusBadge badge;
    switch (p.status) {
      case AuctionStatus.live:     badge = StatusBadge.live(); break;
      case AuctionStatus.upcoming: badge = StatusBadge.upcoming(); break;
      case AuctionStatus.ended:    badge = StatusBadge.ended(); break;
    }

    return DataRow(cells: [
      DataCell(Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(p.imageUrl, width: 44, height: 44, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 44, height: 44,
                  color: AppTheme.background, child: const Icon(Icons.image, color: AppTheme.textMuted))),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(p.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          Text(p.category, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ]),
      ])),
      DataCell(badge),
      DataCell(Text('\$${p.startPrice.toStringAsFixed(0)}')),
      DataCell(Text(
        p.currentBid != null ? '\$${p.currentBid!.toStringAsFixed(0)}' : '—',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: p.currentBid != null ? AppTheme.success : AppTheme.textMuted,
        ),
      )),
      DataCell(Text('${p.bidCount}')),
      DataCell(Text(p.endTime)),
      DataCell(Row(children: [
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/bid-history'),
          style: TextButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
          child: Text(p.status == AuctionStatus.ended ? 'Winner' : 'View', style: const TextStyle(fontSize: 13)),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/add-product'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.textSecondary,
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          child: Text(p.status == AuctionStatus.ended ? 'History' : 'Edit', style: const TextStyle(fontSize: 13)),
        ),
      ])),
    ]);
  }
}
