import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_shell.dart';
import '../widgets/common_widgets.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String _selectedCategory = 'Select category';
  String _selectedDuration = '1 Day';
  bool _isDragging = false;

  final List<String> _categories = ['Select category', 'Electronics', 'Fashion', 'Home & Garden', 'Sports', 'Wearables'];
  final List<String> _durations = ['1 Day', '2 Days', '3 Days', '1 Week', 'Custom'];

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      currentRoute: '/add-product',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create New Product',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    Text('Fill in the details below to list a new auction item',
                        style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Form card
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: AppTheme.cardShadow,
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: 'Basic Information', icon: Icons.info_outline_rounded),
                  const SizedBox(height: 20),

                  // Title (full width)
                  const AppTextField(
                    label: 'Product Title *',
                    hint: 'e.g., Wireless Bluetooth Headphones',
                  ),
                  const SizedBox(height: 20),

                  // Description (full width)
                  const AppTextField(
                    label: 'Description',
                    hint: 'Detailed product description...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 20),

                  // Two column row
                  _twoColumn(
                    _DropdownField(
                      label: 'Category',
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (v) => setState(() => _selectedCategory = v!),
                    ),
                    const AppTextField(
                      label: 'Starting Price (\$) *',
                      hint: '100',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Divider(color: AppTheme.cardBorder, height: 32),
                  _SectionLabel(label: 'Auction Settings', icon: Icons.gavel_rounded),
                  const SizedBox(height: 20),

                  _twoColumn(
                    const AppTextField(
                      label: 'Bid Start Date & Time *',
                      hint: 'Select date & time',
                      suffixIcon: Icon(Icons.calendar_today_rounded, size: 18, color: AppTheme.textSecondary),
                    ),
                    _DropdownField(
                      label: 'Bidding Duration *',
                      value: _selectedDuration,
                      items: _durations,
                      onChanged: (v) => setState(() => _selectedDuration = v!),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _twoColumn(
                    const AppTextField(
                      label: 'Minimum Bid Increment (\$)',
                      hint: '5',
                      keyboardType: TextInputType.number,
                    ),
                    const AppTextField(
                      label: 'Reserve Price (\$) (Optional)',
                      hint: 'Minimum acceptable price',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Divider(color: AppTheme.cardBorder, height: 32),
                  _SectionLabel(label: 'Product Images', icon: Icons.image_outlined),
                  const SizedBox(height: 16),

                  // Image upload area
                  GestureDetector(
                    onTap: () {},
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isDragging = true),
                      onExit: (_) => setState(() => _isDragging = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 140,
                        decoration: BoxDecoration(
                          color: _isDragging ? AppTheme.primaryLight : AppTheme.background,
                          border: Border.all(
                            color: _isDragging ? AppTheme.primary : const Color(0xFFD1D5DB),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined,
                                size: 36,
                                color: _isDragging ? AppTheme.primary : AppTheme.textMuted),
                            const SizedBox(height: 8),
                            Text(
                              'Click to upload or drag and drop',
                              style: TextStyle(
                                fontSize: 14,
                                color: _isDragging ? AppTheme.primary : AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text('PNG, JPG up to 5MB',
                                style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                          icon: const Icon(Icons.publish_rounded, size: 18),
                          label: const Text('Publish Product'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.save_outlined, size: 18),
                          label: const Text('Save as Draft'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _twoColumn(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 20),
        Expanded(child: right),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 18, color: AppTheme.primary),
      const SizedBox(width: 8),
      Text(label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
    ]);
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(),
          style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, fontFamily: 'Poppins'),
        ),
      ],
    );
  }
}
