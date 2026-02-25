import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const AdminShell({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            _Sidebar(currentRoute: currentRoute),
            Expanded(child: child),
          ],
        ),
      );
    }

    if (context.isTablet) {
      return Scaffold(
        body: Row(
          children: [
            _CollapsedSidebar(currentRoute: currentRoute),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: _MobileAppBar(currentRoute: currentRoute),
      drawer: _DrawerSidebar(currentRoute: currentRoute),
      body: child,
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem(this.icon, this.label, this.route);
}

const List<_NavItem> _navItems = [
  _NavItem(Icons.dashboard_rounded,   'Dashboard',   '/dashboard'),
  _NavItem(Icons.inventory_2_rounded, 'Products',    '/products'),
  _NavItem(Icons.add_box_rounded,     'Add Product', '/add-product'),
  _NavItem(Icons.gavel_rounded,       'Bid History', '/bid-history'),
  _NavItem(Icons.people_rounded,      'Users',       '/users'),
  _NavItem(Icons.bar_chart_rounded,   'Analytics',   '/analytics'),
  _NavItem(Icons.settings_rounded,    'Settings',    '/settings'),
];

class _Sidebar extends StatelessWidget {
  final String currentRoute;
  const _Sidebar({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppTheme.sidebarBg,
      child: Column(
        children: [
          _SidebarLogo(showLabel: true),
          const Divider(color: Color(0xFF374151), height: 1),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              children: _navItems.map((item) => _SidebarNavItem(
                item: item,
                isActive: currentRoute == item.route,
                showLabel: true,
              )).toList(),
            ),
          ),
          const Divider(color: Color(0xFF374151), height: 1),
          _SidebarUserTile(showLabel: true),
        ],
      ),
    );
  }
}

class _CollapsedSidebar extends StatelessWidget {
  final String currentRoute;
  const _CollapsedSidebar({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      color: AppTheme.sidebarBg,
      child: Column(
        children: [
          _SidebarLogo(showLabel: false),
          const Divider(color: Color(0xFF374151), height: 1),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              children: _navItems.map((item) => _SidebarNavItem(
                item: item,
                isActive: currentRoute == item.route,
                showLabel: false,
              )).toList(),
            ),
          ),
          const Divider(color: Color(0xFF374151), height: 1),
          _SidebarUserTile(showLabel: false),
        ],
      ),
    );
  }
}

class _DrawerSidebar extends StatelessWidget {
  final String currentRoute;
  const _DrawerSidebar({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.sidebarBg,
      child: Column(
        children: [
          _SidebarLogo(showLabel: true),
          const Divider(color: Color(0xFF374151), height: 1),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              children: _navItems.map((item) => _SidebarNavItem(
                item: item,
                isActive: currentRoute == item.route,
                showLabel: true,
                closeDrawerOnTap: true,
              )).toList(),
            ),
          ),
          const Divider(color: Color(0xFF374151), height: 1),
          _SidebarUserTile(showLabel: true),
        ],
      ),
    );
  }
}

class _MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute;
  const _MobileAppBar({required this.currentRoute});

  String get _title {
    switch (currentRoute) {
      case '/dashboard':   return 'Dashboard';
      case '/add-product': return 'Add Product';
      case '/bid-history': return 'Bid History';
      default:             return 'BidAdmin';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.sidebarBg,
      foregroundColor: Colors.white,
      title: Row(children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(6)),
          child: const Icon(Icons.gavel, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        Text(_title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ]),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SidebarLogo extends StatelessWidget {
  final bool showLabel;
  const _SidebarLogo({required this.showLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(showLabel ? 20 : 14),
      child: Row(
        mainAxisAlignment: showLabel ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.gavel, color: Colors.white, size: 18),
          ),
          if (showLabel) ...[
            const SizedBox(width: 10),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('BidAdmin',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              Text('Admin Portal',
                  style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
            ]),
          ],
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final bool showLabel;
  final bool closeDrawerOnTap;

  const _SidebarNavItem({
    required this.item,
    required this.isActive,
    required this.showLabel,
    this.closeDrawerOnTap = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Tooltip(
        message: showLabel ? '' : item.label,
        preferBelow: false,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              if (closeDrawerOnTap) Navigator.pop(context);
              Navigator.pushReplacementNamed(context, item.route);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: showLabel ? 12 : 10, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primary.withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: showLabel
                  ? Row(children: [
                      Icon(item.icon, size: 18,
                          color: isActive ? AppTheme.primary : const Color(0xFF9CA3AF)),
                      const SizedBox(width: 12),
                      Text(item.label, style: TextStyle(
                        color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 14,
                      )),
                    ])
                  : Center(
                      child: Icon(item.icon, size: 20,
                          color: isActive ? AppTheme.primary : const Color(0xFF9CA3AF)),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarUserTile extends StatelessWidget {
  final bool showLabel;
  const _SidebarUserTile({required this.showLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(showLabel ? 16 : 12),
      child: showLabel
          ? Row(children: [
              CircleAvatar(
                radius: 17, backgroundColor: AppTheme.primary,
                child: const Text('A',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const SizedBox(width: 10),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Admin User',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('Super Admin',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
              ])),
              Icon(Icons.logout_rounded, color: Colors.grey[500], size: 17),
            ])
          : Center(
              child: CircleAvatar(
                radius: 14, backgroundColor: AppTheme.primary,
                child: const Text('A',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
    );
  }
}
