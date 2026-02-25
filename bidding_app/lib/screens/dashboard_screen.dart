import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../widgets/admin_shell.dart';
import '../widgets/common_widgets.dart';

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
      'Live': AuctionStatus.live,
      'Ended': AuctionStatus.ended,
    };
    return sampleProducts.where((p) => p.status == statusMap[_filter]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      currentRoute: '/dashboard',
      child: Column(
        children: [
          // Top header bar
          _DashboardHeader(
            onAddProduct: () => Navigator.pushNamed(context, '/add-product'),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  _StatsRow(),
                  const SizedBox(height: 28),

                  // Product table card
                  Container(
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
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Product List',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                              ),
                              _FilterTabs(
                                selected: _filter,
                                onChanged: (v) => setState(() => _filter = v),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ProductTable(products: _filteredProducts),
                      ],
                    ),
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

class _DashboardHeader extends StatelessWidget {
  final VoidCallback onAddProduct;
  const _DashboardHeader({required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product Dashboard',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
              SizedBox(height: 2),
              Text('Manage bidding products and view analytics',
                  style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 13)),
            ],
          ),
          ElevatedButton.icon(
            onPressed: onAddProduct,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add New Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
              textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8,
        children: const [
          StatCard(
            label: 'Total Products',
            value: '24',
            subtitle: '↑ 12% from last month',
            valueColor: AppTheme.textPrimary,
          ),
          StatCard(
            label: 'Live Auctions',
            value: '8',
            subtitle: 'Active bidding now',
            valueColor: AppTheme.warning,
          ),
          StatCard(
            label: 'Total Bids',
            value: '342',
            subtitle: '↑ 28% increase',
            valueColor: AppTheme.primary,
          ),
          StatCard(
            label: 'Revenue',
            value: '\$45.2K',
            subtitle: '↑ 18% growth',
            valueColor: AppTheme.success,
          ),
        ],
      );
    });
  }
}

class _FilterTabs extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _FilterTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['All', 'Upcoming', 'Live', 'Ended'].map((label) {
        final isActive = selected == label;
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: InkWell(
            onTap: () => onChanged(label),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primary : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

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
          DataColumn(label: Text('Product', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('Start Price', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('Current Bid', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('Bids', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('End Time', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          DataColumn(label: Text('Actions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
        ],
        rows: products.map((product) => _buildRow(context, product)).toList(),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, Product p) {
    StatusBadge badge;
    switch (p.status) {
      case AuctionStatus.live:
        badge = StatusBadge.live();
        break;
      case AuctionStatus.upcoming:
        badge = StatusBadge.upcoming();
        break;
      case AuctionStatus.ended:
        badge = StatusBadge.ended();
        break;
    }

    return DataRow(
      cells: [
        DataCell(Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(p.imageUrl, width: 44, height: 44, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 44, height: 44, color: AppTheme.background,
                    child: const Icon(Icons.image, color: AppTheme.textMuted))),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(p.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text(p.category, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ]),
        ])),
        DataCell(badge),
        DataCell(Text('\$${p.startPrice.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary))),
        DataCell(Text(
          p.currentBid != null ? '\$${p.currentBid!.toStringAsFixed(0)}' : '—',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: p.currentBid != null ? AppTheme.success : AppTheme.textMuted,
          ),
        )),
        DataCell(Text('${p.bidCount}', style: const TextStyle(fontSize: 14))),
        DataCell(Text(p.endTime, style: const TextStyle(fontSize: 14))),
        DataCell(Row(children: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/bid-history'),
            style: TextButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
            child: Text(p.status == AuctionStatus.ended ? 'Winner' : 'View',
                style: const TextStyle(fontSize: 13)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/add-product'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(p.status == AuctionStatus.ended ? 'History' : 'Edit',
                style: const TextStyle(fontSize: 13)),
          ),
        ])),
      ],
    );
  }
}
