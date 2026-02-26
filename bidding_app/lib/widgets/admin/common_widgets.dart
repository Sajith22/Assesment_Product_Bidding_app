import 'package:flutter/material.dart';
import '../../theme/admin_theme.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color valueColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
    this.valueColor = AppTheme.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: valueColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const StatusBadge({super.key, required this.label, required this.bg, required this.fg});

  factory StatusBadge.live() => const StatusBadge(
        label: 'Live',
        bg: Color(0xFFFEF3C7),
        fg: Color(0xFF92400E),
      );

  factory StatusBadge.upcoming() => const StatusBadge(
        label: 'Upcoming',
        bg: Color(0xFFDBEAFE),
        fg: Color(0xFF1E40AF),
      );

  factory StatusBadge.ended() => const StatusBadge(
        label: 'Ended',
        bg: Color(0xFFF3F4F6),
        fg: Color(0xFF374151),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final Widget? suffixIcon;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
        const SizedBox(height: 6),
        TextFormField(
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppTheme.textMuted),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
